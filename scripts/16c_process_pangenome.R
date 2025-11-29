library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
# -----------------
# 0) Inputs
# -----------------
wd <- "C:/Users/yanni/OneDrive - Universitaet Bern/Master/Genome_Annotation" # set your working directory where the pangenome_matrix.rds is located
focal_genome <- "Hiroshima" # Your focal accession name
pangenome <- readRDS(file.path(wd, "pangenome_matrix.rds"))

# genome columns are list-columns produced by query_pangenes()
genome_cols <- names(pangenome)[sapply(pangenome, is.list)]

# Check that the genomes are as expected
genome_cols

pg <- tibble::as_tibble(pangenome)


# Remove out-of-synteny genes (IDs ending with '*') from all genome list-columns
clean_gene_list <- function(v) {
  if (is.null(v) || length(v) == 0) {
    return(character(0))
  }
  v <- as.character(v)
  v <- v[!is.na(v)]
  v <- trimws(v)
  v <- v[!grepl("\\*$", v)] # drop genes ending with '*'
  unique(v)
}

pg <- pg %>%
  mutate(across(all_of(genome_cols), ~ lapply(.x, clean_gene_list)))

# Remove orthogroups that are now empty in ALL genomes after cleaning
# (i.e., all genome columns have length 0)
pg <- pg %>%
  rowwise() %>%
  filter(
    sum(sapply(c_across(all_of(genome_cols)), length)) > 0
  ) %>%
  ungroup()


# Check the pangenome table
head(pg)


# How many orthogroups are there?
nrow(pg)

# -----------------
# 1) Presence/absence per genome (orthogroup-level)
#    TRUE if the cell has a non-empty list of gene IDs
# -----------------
presence_tbl <- pg %>%
  transmute(
    pgID,
    across(
      all_of(genome_cols),
      ~ lengths(.x) > 0,
      .names = "{.col}"
    )
  )

# Check the presence table
head(presence_tbl)


# -----------------
# 2) Global orthogroup flags
# -----------------
n_genomes <- length(genome_cols)

pg_flags <- presence_tbl %>%
  mutate(
    # Count how many genomes have each orthogroup
    n_present = select(., all_of(genome_cols)) %>% rowSums(),

    # Core = present in ALL genomes
    is_core_all = (n_present == n_genomes),

    # Accessory = present in SOME genomes (not all)
    is_accessory = (n_present < n_genomes),

    # Is this orthogroup in our focal genome?
    present_in_focal = .data[[focal_genome]],

    # Focal-specific = ONLY in focal genome
    focal_specific = (present_in_focal & n_present == 1),

    # Lost in focal = present in other genomes but NOT focal
    lost_in_focal = (!present_in_focal & n_present > 0),

    # Almost-core lost in focal = in all genomes EXCEPT focal
    lost_core_without_focal = (!present_in_focal & n_present == (n_genomes - 1)),

    # Identify genes lost compared to TAIR10
    lost_vs_TAIR10 = (!present_in_focal) & .data[["TAIR10"]]
  ) %>%
  # Add simple category labels
  mutate(
    category = case_when(
      is_core_all ~ "core",
      n_present == 1 ~ "accession_specific",
      TRUE ~ "accessory"
    )
  )

# Check the flags table
head(data.frame(pg_flags))
table(pg_flags$category)

# -----------------
# 3) GENE counts per orthogroup × genome
#    convert list entries to integer counts = number of unique gene IDs
# -----------------
count_genes <- function(gene_list) {
  if (is.null(gene_list) || length(gene_list) == 0) {
    return(0)
  }
  # Count unique genes
  length(unique(gene_list))
}

# Apply the function to all genome columns
gene_counts_matrix <- pg %>%
  select(pgID, all_of(genome_cols)) %>%
  mutate(across(
    all_of(genome_cols),
    ~ sapply(.x, count_genes)
  ))

# Check the gene counts matrix
head(gene_counts_matrix)

# -----------------
# 4) GENE counts per genome & category
# -----------------
# add category to the matrix
gene_counts_w_cat <- pg_flags %>%
  select(pgID, category) %>%
  left_join(gene_counts_matrix, by = "pgID")

# Calculate total genes per genome (sum gene counts by category)
gene_by_cat <- gene_counts_w_cat %>%
  pivot_longer(cols = all_of(genome_cols), names_to = "genome", values_to = "gene_count") %>%
  group_by(genome, category) %>%
  summarise(gene_count = sum(gene_count), .groups = "drop")

# Define the columns for which to calculate the sum.
columns_to_sum <- c("Etna_2", "Ice_1", "Hiroshima", "TAIR10", "Taz_0")

# calculate total orthogroups per genome (sum orthogroup counts by category)
og_by_cat <- pg_flags %>%
  group_by(category) %>%
  summarise(
    # Use across() to apply the sum function to multiple columns dynamically.
    # .names = "sum_{.col}" creates new column names like "sum_Etna_2".
    across(all_of(columns_to_sum), sum, .names = "sum_{.col}")
  ) %>%
  pivot_longer(
    cols = starts_with("sum_"), # Selects all columns that start with "sum_"
    names_to = "genome",        # Creates a new column named 'genome' for the original column names
    values_to = "orthogroup_count"    # Creates a new column named 'orthogroup_count' for the sum values
  ) %>%
  mutate(
    genome = sub("sum_", "", genome) # Remove the "sum_" prefix from the 'genome' names
  ) %>%
  arrange(genome, category)

# Combine gene_by_cat with og_by_cat
combined_df <- full_join(gene_by_cat, og_by_cat, by = c("genome", "category"))

# Reshape the data from wide to long format
data_long <- combined_df %>%
  pivot_longer(cols = c(gene_count, orthogroup_count),
               names_to = "count_type",
               values_to = "count_value")

# This ensures 'core' is at the bottom, then 'accessory', then 'species_specific'
# and 'gene_count' facet appears before 'orthogroup_count'
data_long$category <- factor(data_long$category, levels = c("accession_specific", "accessory", "core"))
data_long$count_type <- factor(data_long$count_type, levels = c("gene_count", "orthogroup_count"))

color_scheme <- c("#88CCEE", "#DDCCEE", "#332288") # Cyan, Pale purple, Dark blue

# plot the data
ggplot(data_long, aes(x = genome, y = count_value, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ count_type, ncol = 2, scales = "fixed") +
  scale_fill_manual(values = color_scheme) + # Apply the custom color palette here
  labs(
    title = "",
    x = "Genome",
    y = "Count",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    plot.title = element_text(hjust = 0.5) # Center the plot title
  )

ggsave(file.path(wd, "plots/16a_pangenome_frequency_plot.pdf"), width = 10, height = 6)

# Total genes per genome (sum across all categories)
gene_totals <- gene_by_cat %>%
  group_by(genome) %>%
  summarise(gene_total = sum(gene_count), .groups = "drop")

# spread categories for a per-genome wide table
gene_counts_per_genome <- gene_by_cat %>%
  pivot_wider(names_from = category, values_from = gene_count, values_fill = 0) %>%
  rename(
    gene_core = core,
    gene_accessory = accessory,
    gene_specific = accession_specific
  ) %>%
  left_join(gene_totals, by = "genome") %>%
  mutate(
    # Calculate percentages of genes by category
    percent_core = round(100 * gene_core / pmax(gene_total, 1), 2),
    percent_specific = round(100 * gene_specific / pmax(gene_total, 1), 2)
  )

# Check the gene counts per genome
head(data.frame(gene_counts_per_genome))


# -----------------
# 5) Pangenome frequency plot: OGs and genes in n genomes
# -----------------

#  Count orthogroups by number of genomes they're present in
og_freq <- pg_flags %>%
  count(n_present, name = "count") %>%
  mutate(type = "Orthogroups")

# Count gene, how many present in orthogroups present in n genomes
# Create a long table of (pgID, genome, gene) and attach the orthogroup-level n_present
all_genes_with_presence <- pg %>%
  select(pgID, all_of(genome_cols)) %>%
  pivot_longer(cols = all_of(genome_cols), names_to = "genome", values_to = "genes_list") %>%
  # drop empty/null lists
  filter(!sapply(genes_list, is.null) & sapply(genes_list, length) > 0) %>%
  unnest_longer(genes_list) %>%
  rename(gene = genes_list) %>%
  filter(!is.na(gene)) %>%
  mutate(gene = as.character(gene)) %>%
  distinct(pgID, genome, gene) %>% # one row per distinct gene occurrence in a pgID/genome
  left_join(select(pg_flags, pgID, n_present), by = "pgID")



# Count genes by the n_present of their orthogroup.
# This counts unique gene × orthogroup occurrences.
gene_freq <- all_genes_with_presence %>%
  distinct(pgID, gene, n_present) %>% # unique gene in each orthogroup
  count(n_present, name = "count") %>%
  mutate(type = "Genes")

# Combine both
freq_data <- bind_rows(og_freq, gene_freq)

# Plot with better formatting
ggplot(freq_data, aes(x = n_present, y = count, fill = type)) +
  geom_col(position = "dodge", alpha = 0.8, width = 0.7) +
  scale_x_continuous(
    breaks = 1:n_genomes,
    labels = 1:n_genomes
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Genes" = "#0072B2", "Orthogroups" = "#D55E00")) +
  labs(
    x = "Number of genomes",
    y = "Count",
    fill = NULL,
    title = "Pangenome composition: distribution across genomes",
    subtitle = paste("Total genomes:", n_genomes)
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold")
  )

ggsave(file.path(wd, "plots/16b_pangenome_frequency_plot.pdf"), width = 10, height = 6)

# Summary table
freq_summary <- freq_data %>%
  pivot_wider(names_from = type, values_from = count, values_fill = 0) %>%
  mutate(
    label = case_when(
      n_present == n_genomes ~ "Core (all genomes)",
      n_present == 1 ~ "Accession-specific (1 genome)",
      TRUE ~ paste0("Shared (", n_present, " genomes)")
    )
  ) %>%
  arrange(desc(n_present)) %>%
  select(n_present, label, Orthogroups, Genes)

print(freq_summary)
