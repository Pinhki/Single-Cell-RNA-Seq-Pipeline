![Graphic page 2](why_am_i_here_images/ig_023d044a1338d03f016a1b2ba7f2788194acf365930c203f49.png)
![Graphic page 3](why_am_i_here_images/ig_023d044a1338d03f016a1b2c24f8c8819483076664b426a24f.png)
![Graphic page 4](why_am_i_here_images/ig_023d044a1338d03f016a1b2c57067c81948a7a84830f05a670.png)
![Graphic page 5](why_am_i_here_images/ig_023d044a1338d03f016a1b2cbfed988194aa5347b12d9e2658.png)
![Graphic page 6](why_am_i_here_images/ig_023d044a1338d03f016a1b2cee956481948fa48088db2f783a.png)
![Graphic page 7](why_am_i_here_images/ig_023d044a1338d03f016a1b2d32a9f08194bff87898b40be426.png)
![Graphic page 8](why_am_i_here_images/ig_023d044a1338d03f016a1b2d66a28481948588c13671011ebb.png)
![Graphic page 9](why_am_i_here_images/ig_023d044a1338d03f016a1b2d9a20788194af54a4ec10340f5b.png)
![Graphic page 10](why_am_i_here_images/ig_023d044a1338d03f016a1b2ddd3e448194a6b772269bb378ae.png)
![Graphic page 11](why_am_i_here_images/ig_023d044a1338d03f016a1b2e160d1881949822607e6cf46b89.png)

<div class="alert alert-warning" role="alert">
  <strong>Please note.</strong> This page was prepared with AI assistance and reviewed against cited sources. Minor discrepancies may still remain, so please verify critical details against the linked documentation and papers when accuracy is important.
</div>

<div class="card">
  <div class="welcome-block-title">Why Am I Here?</div>
  <p>
    You have just received single-cell RNA-seq data from a recent experiment. You want to focus on biological interpretation and clustering quality, not on coding details.
    This pipeline gives you a guided, GUI-based workflow so routine processing is structured, reproducible, and easier to review.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">How Single-Cell Data Is Represented</div>
  <p>
    Single-cell RNA-seq analysis starts from a <strong>gene-by-cell expression matrix</strong>. Rows are genes, columns are cells, and each value reflects observed expression.
    Clustering and annotation are then built on this matrix.
  </p>
  <div class="alert alert-info" role="alert">
    <strong>Please note.</strong> This matrix is generated <strong>after sequencing reads have been aligned and assigned to features</strong>. At this stage, it is a <strong>count table</strong>, not a sequence file: it preserves how many reads or UMIs were assigned to each gene in each cell, but <strong>it does not retain the underlying read sequences</strong>. Features that are <strong>not represented in the reference genome and annotation used for alignment</strong> are generally not quantified in the matrix. For example, engineered elements such as <strong>GFP</strong>, <strong>Cre</strong>, or <strong>loxP/flox-associated sequence elements</strong> will usually not appear unless they were explicitly included in the reference used for alignment.
  </div>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Gene_expression_matrix.jpg/1280px-Gene_expression_matrix.jpg" alt="Gene expression matrix heatmap" />
  </figure>
  <p class="welcome-tutorial-citation">
    Reference image: <a href="https://commons.wikimedia.org/wiki/File:Gene_expression_matrix.jpg" target="_blank" rel="noopener noreferrer">Gene expression matrix (Wikimedia Commons)</a>, by Dvir Netanely, licensed <a href="https://creativecommons.org/licenses/by-sa/3.0/" target="_blank" rel="noopener noreferrer">CC BY-SA 3.0</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Typical Single-Cell Workflow</div>
  <p>
    A standard workflow has two parts: <strong>library generation in the wet lab</strong>, followed by <strong>computational processing after sequencing</strong>.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.10xgenomics.com/image/upload/f_auto%2Cq_auto%2Cdpr_2.0%2Cw_1200/v1723751588/products/Chromium/chromium-partitioning-library-prep.png" alt="10x Chromium partitioning and library preparation workflow" />
  </figure>
  <p class="welcome-tutorial-citation">
    Reference image: <a href="https://www.10xgenomics.com/platforms/chromium/technology" target="_blank" rel="noopener noreferrer">Chromium GEM-X Technology page (10x Genomics)</a>. This figure shows the wet-lab side: partitioning cells, adding barcodes, and generating sequencing-ready libraries.
  </p>
  <p>
    After sequencing, the first computational step is usually <strong>demultiplexing</strong>. If the sequencing core gives you <strong>BCL files</strong>, these are converted into <strong>sample-specific FASTQ files</strong> using the sample index reads. In current 10x guidance, this step is typically done with <strong>Illumina BCL Convert</strong>. Older workflows may mention <code>cellranger mkfastq</code>, but 10x now marks that route as deprecated.
  </p>
  <p>
    After FASTQ generation, <strong>Cell Ranger</strong> processes each sample by reading the <strong>10x cell barcode</strong> and <strong>UMI</strong>, trimming technical sequences, aligning the cDNA read to the reference, assigning reads to genes, correcting likely barcode or UMI sequencing errors, and collapsing duplicate molecules into counts. The output is first a <strong>raw feature-barcode matrix</strong>, followed by a <strong>filtered matrix</strong> after Cell Ranger decides which barcodes are most likely real cells.
  </p>
  <p>
    In simple terms, <strong>demultiplexing separates sequencing output into sample FASTQ files</strong>, while <strong>Cell Ranger converts those FASTQs into the gene-by-cell count matrix used for downstream analysis</strong>.
  </p>
  <div class="alert alert-info" role="alert">
    <strong>Please note.</strong> Here, demultiplexing means <strong>BCL-to-FASTQ sample separation</strong> at the sequencing-file level. It is different from downstream <strong>cell-level demultiplexing</strong>, such as HTO or CellPlex sample assignment.
  </div>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.10xgenomics.com/image/upload/v1647646941/software-support/3p-Single-Cell-GEX/gex-algo-pipeline.png" alt="10x Cell Ranger gene expression pipeline from FASTQ to alignment, counting, raw matrix, and cell calling" />
  </figure>
  <p class="welcome-tutorial-citation">
    Reference image: <a href="https://www.10xgenomics.com/support/software/cell-ranger/8.0/algorithms-overview/cr-gex-algorithm" target="_blank" rel="noopener noreferrer">Cell Ranger's Gene Expression Algorithm (10x Genomics)</a>. This figure summarizes the computational path from FASTQ input through alignment, counting, raw matrix generation, and cell calling.
  </p>
  <p class="welcome-tutorial-citation">
    Related 10x references: <a href="https://www.10xgenomics.com/support/software/cell-ranger/latest/tutorials/inputs/cr-direct-demultiplexing" target="_blank" rel="noopener noreferrer">Generating FASTQs</a> and <a href="https://www.10xgenomics.com/support/software/cell-ranger/latest/analysis/running-pipelines/cr-gex-count" target="_blank" rel="noopener noreferrer">The Cell Ranger count pipeline</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">What You Should Have Before Starting</div>
  <ul>
    <li>For each sample, a Cell Ranger output matrix (recommended), or a 10x-compatible matrix file (<code>filtered_feature_bc_matrix/</code> folder or <code>.h5</code>).</li>
    <li>If you only have FASTQ files, generate count matrices first (for example, using Cell Ranger or 10x Cloud Analysis).</li>
    <li>10x Cloud references: <a href="https://www.10xgenomics.com/support/software/cloud-analysis/latest" target="_blank" rel="noopener noreferrer">Cloud Analysis overview</a>; <a href="https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/CA-creating-analyses" target="_blank" rel="noopener noreferrer">Create analyses from FASTQ</a>.</li>
  </ul>
</div>

<div class="card">
  <div class="welcome-block-title">Why RNA QC Comes First</div>
  <p>
    Before normalization, clustering, or annotation, it is important to remember that the matrix may still contain a mixture of <strong>good cells</strong>, <strong>low-quality cells</strong>, <strong>background barcodes</strong>, and sometimes <strong>doublets or multiplets</strong>.
    RNA QC is the step where we remove profiles that are unlikely to represent intact single cells.
  </p>
  <p>
    In simple terms, a <strong>good cell</strong> usually has a reasonable number of detected genes, a reasonable total RNA count, and a mitochondrial fraction that does not suggest strong stress or cell damage.
    A <strong>problematic cell</strong> often looks different in one of three ways:
  </p>
  <ul>
    <li><strong>Very low genes or UMIs</strong>: often empty droplets, ambient RNA, or weak captures.</li>
    <li><strong>Very high genes or UMIs</strong>: often doublets or multiplets, where more than one cell entered the same droplet.</li>
    <li><strong>High mitochondrial percentage</strong>: often stressed, dying, or damaged cells that leaked cytoplasmic RNA.</li>
  </ul>
  <p>
    Cell Ranger already performs <strong>cell calling</strong> to distinguish likely cells from background barcodes, but that is not the end of QC.
    Downstream RNA QC is still needed because some low-quality or multiplet profiles can remain even after the initial barcode calling step.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.10xgenomics.com/image/upload/v1722374395/software-support/3p-Single-Cell-GEX/cell-ranger-cell-calling.png" alt="10x Cell Ranger cell-calling schematic distinguishing likely cells from background barcodes" />
  </figure>
  <p class="welcome-tutorial-citation">
    Reference image: <a href="https://www.10xgenomics.com/support/software/cell-ranger/8.0/algorithms-overview/cr-gex-algorithm" target="_blank" rel="noopener noreferrer">Cell Ranger's Gene Expression Algorithm (10x Genomics)</a>. This figure illustrates the barcode-rank and background-comparison idea used during cell calling.
  </p>
  <p>
    In Seurat, these QC features are usually summarized as:
  </p>
  <ul>
    <li><code>nFeature_RNA</code>: how many genes were detected in each cell.</li>
    <li><code>nCount_RNA</code>: how many total RNA molecules or UMIs were counted in each cell.</li>
    <li><code>percent.mt</code>: what fraction of the signal comes from mitochondrial genes.</li>
  </ul>
  <p>
    The exact cutoff values are <strong>dataset-dependent</strong>. There is no universal threshold that fits every tissue, chemistry, or experiment.
    The main goal is to remove clearly poor-quality profiles without accidentally discarding real biology.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://satijalab.org/seurat/articles/pbmc3k_tutorial_files/figure-html/qc2-1.png" alt="Seurat PBMC3K QC violin plots for number of genes, counts, and mitochondrial percentage" />
  </figure>
  <p class="welcome-tutorial-citation">
    Example QC overview from the <a href="https://satijalab.org/seurat/articles/pbmc3k_tutorial" target="_blank" rel="noopener noreferrer">Seurat PBMC3K tutorial</a>: violin plots of <code>nFeature_RNA</code>, <code>nCount_RNA</code>, and <code>percent.mt</code>.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://satijalab.org/seurat/articles/pbmc3k_tutorial_files/figure-html/qc2-2.png" alt="Seurat PBMC3K QC scatter plots showing nCount versus mitochondrial percentage and nCount versus nFeature" />
  </figure>
  <p class="welcome-tutorial-citation">
    Example QC relationships from the same <a href="https://satijalab.org/seurat/articles/pbmc3k_tutorial" target="_blank" rel="noopener noreferrer">Seurat tutorial</a>: scatter plots help identify stressed cells with high mitochondrial RNA and potential doublets with unusually high counts and features.
  </p>
  <p>
    Once this first-pass RNA QC is complete, the remaining matrix is much better suited for normalization, dimensionality reduction, clustering, and annotation.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">How Seurat Works</div>
  <p>
    After basic RNA QC, Seurat is easiest to understand if you picture it as a notebook that keeps <strong>several views of the same cells</strong>.
    It stores the raw count matrix, cell metadata, and then newer representations built from those counts: normalized values, selected informative genes, low-dimensional embeddings, neighbor graphs, clusters, and sometimes an integrated view across samples.
    The point is not to overwrite the raw data, but to keep a chain of increasingly interpretable summaries.
  </p>
  <p>
    Below is the mechanism-first version. This is deeper than a workflow checklist, but it is still written for beginners.
    In practice, many Seurat users make two big choices along the way: <strong>LogNormalize versus SCTransform</strong> for normalization, and <strong>anchor-based integration versus Harmony</strong> for cross-sample alignment.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 1: Counts And The Object</div>
  <p>
    The starting input is a gene-by-cell count matrix. In single-cell data, most entries are zero, so Seurat stores the matrix in a <strong>sparse</strong> format to save memory.
    Those zeros are expected: each cell only expresses a subset of genes, and sequencing only captures a fraction of the RNA molecules that were present.
  </p>
  <p>
    <code>CreateSeuratObject()</code> does not analyze the biology yet. It creates a container that keeps the counts together with sample-level information.
    Two arguments often confuse beginners:
  </p>
  <ul>
    <li><code>min.cells</code> removes genes that are detected in too few cells.</li>
    <li><code>min.features</code> removes cells that express too few genes.</li>
  </ul>
  <p>
    Metadata such as sample name, condition, percent mitochondrial RNA, or later cluster labels are stored separately from the count matrix.
    Seurat also keeps a special concept called <code>Idents()</code>, which is simply the current grouping label you want functions to use by default.
    In other words, identities are not the data themselves; they are the current label Seurat is asked to treat as the main grouping.
  </p>
  <p class="welcome-tutorial-citation">
    Official Seurat references: <a href="https://satijalab.github.io/seurat-object/reference/CreateSeuratObject.html" target="_blank" rel="noopener noreferrer">CreateSeuratObject</a>, <a href="https://satijalab.github.io/seurat-object/reference/Seurat-class.html" target="_blank" rel="noopener noreferrer">Seurat object class</a>, and <a href="https://satijalab.github.io/seurat-object/reference/Idents.html" target="_blank" rel="noopener noreferrer">Idents</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 2: How Normalization Really Works</div>
  <p>
    The default Seurat normalization for standard RNA data is <code>LogNormalize</code>. The idea is simple: cells are sequenced to different depths, so raw counts are not directly comparable.
    A cell with 30,000 captured molecules will tend to have larger raw counts than a biologically similar cell with 8,000 captured molecules.
  </p>
  <p>
    Seurat adjusts this in three steps for each cell:
  </p>
  <ol>
    <li>Take each gene count and divide it by the total counts in that cell.</li>
    <li>Multiply by a constant, usually <code>10,000</code>, so the values are easier to read.</li>
    <li>Apply <code>log1p</code>, meaning <code>log(1 + x)</code>, to compress the dynamic range.</li>
  </ol>
  <p>
    So the default transformation is effectively <code>log1p((gene_count / total_counts_in_cell) * 10000)</code>.
    This means the normalized value is no longer an absolute molecule count. It is closer to a library-size-adjusted relative abundance on a log scale.
  </p>
  <p>
    Why take the log? Because a few genes can otherwise dominate the scale. The log transform squeezes the very large values more than the small values, so common cell-state patterns are easier to compare.
    What normalization <strong>does not</strong> do is remove batch effects, donor effects, chemistry effects, or unwanted biology. It only makes cells more comparable with respect to sequencing depth.
  </p>
  <p>
    One subtle but important point: with <code>LogNormalize</code>, each cell is normalized independently. That is why the normalized value for a given cell is usually the same whether you normalize it alone or inside a merged object, as long as settings are unchanged.
    The context dependence enters later, when Seurat chooses variable features, computes PCA, builds a neighbor graph, and clusters cells.
  </p>
  <p class="welcome-tutorial-citation">
    Official Seurat reference: <a href="https://satijalab.org/seurat/reference/normalizedata" target="_blank" rel="noopener noreferrer">NormalizeData</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 3: SCTransform (SCT) Is A Different Kind Of Normalization</div>
  <p>
    <code>SCTransform()</code> is not just a slightly different log-normalization. It is a different statistical idea.
    Instead of rescaling each cell by one size factor, SCT fits a <strong>regularized negative binomial model</strong> for each gene and uses sequencing depth as a covariate.
    For each gene in each cell, the model asks: <strong>given this gene's average behavior and this cell's sequencing depth, how many counts would we expect?</strong>
  </p>
  <p>
    The key output is the <strong>Pearson residual</strong>:
  </p>
  <ul>
    <li>Positive residual: the gene is more abundant than expected.</li>
    <li>Negative residual: the gene is less abundant than expected.</li>
    <li>Near zero: the observed count is close to what the model expected from technical depth alone.</li>
  </ul>
  <p>
    This matters because SCT is trying to remove depth-driven technical structure at the level of the statistical model, not only by dividing by a cell total.
    In Seurat, this usually replaces <code>NormalizeData()</code>, <code>FindVariableFeatures()</code>, and <code>ScaleData()</code> with one command.
    The normalized values used for PCA are stored as Pearson residuals in the <code>SCT</code> assay.
  </p>
  <p>
    Compared with <code>LogNormalize</code>, the practical difference is:
  </p>
  <ul>
    <li><code>LogNormalize</code> is simple per-cell rescaling followed by a log transform.</li>
    <li><code>SCTransform</code> is a gene-wise model that performs normalization and variance stabilization together.</li>
    <li><code>LogNormalize</code> usually needs a separate highly variable gene step.</li>
    <li><code>SCTransform</code> uses residual variance to decide which genes remain informative.</li>
  </ul>
  <p>
    Beginners should also know one practical consequence: SCT can reduce depth-related artifacts more strongly, but it is more computationally demanding and the main analysis space is no longer plain log-normalized expression.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.ncbi.nlm.nih.gov/pmc/blobs/64b5/6927181/2736705b0aa7/13059_2019_1874_Fig6_HTML.jpg" alt="Comparison of log-normalization and Pearson residuals showing reduced sequencing-depth confounding" />
  </figure>
  <p class="welcome-tutorial-citation">
    Figure reference: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC6927181/" target="_blank" rel="noopener noreferrer">Hafemeister and Satija, 2019</a>. This figure illustrates that Pearson-residual-based normalization reduces sequencing-depth confounding more strongly than simple log-normalization. Additional Seurat references: <a href="https://satijalab.org/seurat/reference/sctransform" target="_blank" rel="noopener noreferrer">SCTransform</a> and <a href="https://satijalab.org/seurat/articles/sctransform_vignette.html" target="_blank" rel="noopener noreferrer">Using sctransform in Seurat</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 4: How It Finds Informative Genes</div>
  <p>
    After normalization, Seurat usually does not treat every gene as equally useful for defining cell structure.
    Many genes vary mainly because of sampling noise or because they are expressed at very low levels.
    What we want are genes whose cell-to-cell variation is larger than expected for their average abundance.
  </p>
  <p>
    In the default <code>vst</code> approach used by <code>FindVariableFeatures()</code>, Seurat estimates the relationship between a gene's average expression and its variance.
    This matters because high-expression genes naturally have different variance behavior than low-expression genes.
    Seurat fits that mean-variance trend, then asks: <strong>for a gene expressed at this level, is its variance unusually high?</strong>
  </p>
  <p>
    Genes with unusually high standardized variance become the highly variable features.
    These genes are important because PCA, neighbor finding, and clustering are mostly driven by them.
    In practical terms, this step decides which parts of the transcriptome are allowed to define the shape of the dataset.
  </p>
  <p>
    In the standard log-normalization workflow, Seurat calls these genes with <code>FindVariableFeatures()</code>.
    In an SCT workflow, the same idea is still present, but the ranking is based on residual variance from the fitted model rather than on the log-normalized matrix.
  </p>
  <p>
    That is why two analyses that start from the same count matrix can still diverge later: if they choose different variable genes, they build different PCA spaces, different neighbor graphs, and often different clusters.
  </p>
  <p class="welcome-tutorial-citation">
    Official Seurat reference: <a href="https://satijalab.org/seurat/reference/findvariablefeatures" target="_blank" rel="noopener noreferrer">FindVariableFeatures</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 5: How Anchor Integration Works</div>
  <p>
    Seurat's built-in integration route is usually <strong>anchor-based integration</strong>.
    Its goal is to align multiple datasets so that the same biology sits closer together, instead of being separated mainly by donor, batch, condition, or chemistry.
    The important beginner idea is this: <strong>integration is not just merging</strong>.
    Merging stacks cells together. Integration actively tries to build a corrected representation in which comparable cell states line up across datasets.
  </p>
  <p>
    The classic Seurat integration vignette shows this visually: before integration, the same cell states can split apart by condition; after integration, matching cell states sit closer together in a shared embedding.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://satijalab.org/seurat/articles/integration_introduction_files/figure-html/unintegratedUMAP-1.png" alt="Seurat vignette UMAP before integration showing CTRL and STIM cells separated by condition" />
  </figure>
  <p class="welcome-tutorial-citation">
    Before integration: UMAP from the <a href="https://satijalab.org/seurat/articles/integration_introduction.html" target="_blank" rel="noopener noreferrer">official Seurat integration vignette</a>, showing the CTRL and STIM PBMC datasets before alignment.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://satijalab.org/seurat/articles/integration_introduction_files/figure-html/viz-1.png" alt="Seurat vignette UMAP after integration showing improved mixing of CTRL and STIM cells" />
  </figure>
  <p class="welcome-tutorial-citation">
    After integration: UMAP from the same <a href="https://satijalab.org/seurat/articles/integration_introduction.html" target="_blank" rel="noopener noreferrer">Seurat vignette</a>, showing improved mixing of matched cell states after integration.
  </p>
  <p>
    In Seurat's anchor-based framework, the method first looks for cell pairs from different datasets that appear to represent similar biological states.
    These are called <strong>anchors</strong>.
    You can think of an anchor as a trustworthy cross-dataset match: "this cell in sample A looks like that cell in sample B."
  </p>
  <p>
    To find anchors, Seurat places datasets into a shared low-dimensional space, classically using canonical correlation analysis followed by additional processing.
    It then looks for mutual nearest neighbors across datasets.
    Those cross-dataset matches are scored, weaker matches are downweighted, and the information from many anchors is used to estimate correction vectors.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.ncbi.nlm.nih.gov/pmc/blobs/3b11/6687398/1f35f21514d3/nihms-1530582-f0002.jpg" alt="Anchor integration schematic from Stuart et al showing reference, query, anchor identification, and integrated embedding" />
  </figure>
  <p class="welcome-tutorial-citation">
    Mechanism figure: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC6687398/" target="_blank" rel="noopener noreferrer">Stuart et al., 2019</a>. This schematic shows the anchor-based idea directly: place reference and query in a shared space, identify high-scoring cross-dataset correspondences, and use those anchors to guide integration.
  </p>
  <p>
    The result is a separate integrated representation for downstream alignment-focused tasks such as PCA, neighbor finding, clustering, and UMAP.
    The raw RNA counts are still kept. That distinction matters a lot: integration changes the space you cluster in, not the fact that your original counts existed.
  </p>
  <p>
    Integration is powerful, but it is also a scientific choice. If samples truly differ because of treatment or disease, over-aggressive integration can hide real biology.
    So the real question is never "should we integrate?" in the abstract. The real question is "which differences are technical and should be aligned, and which differences are biological and should remain visible?"
  </p>
  <p class="welcome-tutorial-citation">
    Seurat integration references: <a href="https://satijalab.org/seurat/articles/integration_introduction.html" target="_blank" rel="noopener noreferrer">official integration vignette</a> and <a href="https://pubmed.ncbi.nlm.nih.gov/31178118/" target="_blank" rel="noopener noreferrer">Stuart et al., 2019, Cell</a>, which introduced Seurat's anchor-based integration framework.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Seurat Mechanism 6: Harmony Corrects The Embedding Instead</div>
  <p>
    Harmony is a different integration strategy that is widely used inside Seurat workflows.
    Instead of first building explicit cross-dataset anchor pairs, Harmony starts from an existing low-dimensional embedding, usually PCA on a merged object, and then corrects that embedding directly.
  </p>
  <p>
    Mechanistically, Harmony does four things in a loop:
  </p>
  <ol>
    <li>Soft-cluster cells in the embedding.</li>
    <li>Check whether clusters are too dominated by one batch, donor, or dataset.</li>
    <li>Estimate dataset-specific correction terms for each cluster.</li>
    <li>Move each cell by a weighted combination of those corrections, then repeat until stable.</li>
  </ol>
  <p>
    So Harmony is an <strong>embedding correction method</strong>.
    In Seurat workflows, the RNA counts stay as they are, and Harmony usually writes a new dimensional reduction such as <code>harmony</code>.
    Downstream steps like neighbor finding, clustering, and UMAP then use that corrected embedding instead of the original PCA coordinates.
  </p>
  <p>
    Compared with Seurat anchor integration:
  </p>
  <ul>
    <li>Anchor integration is match-based: it tries to identify corresponding cells across datasets.</li>
    <li>Harmony is embedding-based: it iteratively corrects the low-dimensional coordinates themselves.</li>
    <li>Anchor integration often creates an integrated representation from a list of datasets.</li>
    <li>Harmony often feels lighter and more flexible when you want to correct donor or batch effects on an already merged analysis.</li>
  </ul>
  <p>
    Neither method is automatically superior. They make different assumptions, and both can overcorrect if a real biological difference is treated as a nuisance batch effect.
  </p>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://portals.broadinstitute.org/harmony/articles/main.jpg" alt="Harmony integration algorithm schematic showing iterative soft clustering and correction" />
  </figure>
  <p class="welcome-tutorial-citation">
    Figure reference: <a href="https://portals.broadinstitute.org/harmony/index.html" target="_blank" rel="noopener noreferrer">Harmony documentation</a>. Method references: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC6884693/" target="_blank" rel="noopener noreferrer">Korsunsky et al., 2019</a> and Seurat's <a href="https://satijalab.org/seurat/reference/harmonyintegration" target="_blank" rel="noopener noreferrer">HarmonyIntegration</a> reference.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Why We Stay Close To The Analysis</div>
  <p>
    This is not about replacing bioinformaticians. It is about staying close enough to the analysis that important choices are made consciously instead of silently.
    In single-cell work, package choice, version choice, defaults, and preprocessing decisions can all change the result you finally interpret as biology.
  </p>
  <p>
    So when we say you should understand your own pipeline, what we really mean is: you should understand which decisions are scientific decisions.
    Once you see that clearly, conversations with collaborators become much better because you are no longer asking for "a standard analysis."
    You are asking for a defined analysis.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Evidence 1: Different Packages Can Disagree On The Same Data</div>
  <p>
    A recent Pachter-lab study compared Seurat and Scanpy step by step and showed that even widely used default workflows do not necessarily produce the same answer from the same count matrix.
  </p>
  <ul>
    <li>The overlap of highly variable genes was low: Jaccard index <strong>0.22</strong>.</li>
    <li>The overlap of shared-nearest-neighbor neighborhoods was even lower: median Jaccard <strong>0.11</strong>.</li>
    <li>For differential expression, about <strong>20%</strong> of adjusted p-values crossed the 0.05 significance threshold in opposite directions between the two packages.</li>
    <li>The size of the discrepancy was comparable to severely downsampling the experiment, roughly to less than 5% of reads or less than 20% of cells depending on the metric.</li>
  </ul>
  <p>
    In plain language: two competent analysts can both run "default standard workflows" and still hand you different clusters, different markers, and sometimes different biological stories.
  </p>
  <p class="welcome-tutorial-citation">
    Evidence source: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC11014608/" target="_blank" rel="noopener noreferrer">Rich et al., 2024, PMC full text</a>; PubMed record <a href="https://pubmed.ncbi.nlm.nih.gov/38617255/" target="_blank" rel="noopener noreferrer">here</a>. PubMed currently labels this item as a preprint.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Evidence 2: Normalization And Pipeline Choices Can Be As Important As More Data</div>
  <p>
    Vieth and colleagues systematically evaluated about <strong>3,000</strong> single-cell RNA-seq pipelines and found that normalization and library preparation were among the strongest drivers of downstream performance.
    Their headline message was especially striking: choosing a good pipeline could have an effect similar to <strong>quadrupling the sample size</strong>.
  </p>
  <p>
    Tian and colleagues expanded the benchmarking idea across <strong>3,913</strong> method combinations covering normalization, imputation, clustering, trajectory analysis, and integration.
    Their result was not "one package wins forever." Their result was that different tasks favor different method combinations.
    That means there is no universal default that is guaranteed to be best for every dataset and every biological question.
  </p>
  <p>
    In human terms: if your workflow choices can buy you performance comparable to a much larger experiment, then those choices are not housekeeping.
    They are part of the experiment's interpretive layer.
  </p>
  <p class="welcome-tutorial-citation">
    Evidence sources: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC6789098/" target="_blank" rel="noopener noreferrer">Vieth et al., 2019, Nature Communications</a> and <a href="https://www.nature.com/articles/s41592-019-0425-8" target="_blank" rel="noopener noreferrer">Tian et al., 2019, Nature Methods</a>.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">Evidence 3: Integration Methods Trade Batch Removal Against Biology Preservation</div>
  <p>
    Luecken and colleagues benchmarked <strong>68</strong> integration-method and preprocessing combinations across <strong>85 batches</strong>, <strong>23 publications</strong>, and more than <strong>1.2 million cells</strong>.
    Their conclusion was not that one method is always best.
    Instead, different methods balance two competing goals differently:
  </p>
  <ul>
    <li>Remove batch effects strongly enough that matching cell states mix across datasets.</li>
    <li>Preserve true biological variation instead of washing it out.</li>
  </ul>
  <p>
    They also showed that preprocessing decisions matter here too: highly variable gene selection often improved integration, while scaling tended to push methods toward stronger batch removal at the expense of biological conservation.
  </p>
  <p>
    This is exactly why "please integrate the samples" is incomplete. The real decision is what kind of alignment you want, what biology must be preserved, and what tradeoff is acceptable for your question.
  </p>
  <p class="welcome-tutorial-citation">
    Evidence source: <a href="https://pmc.ncbi.nlm.nih.gov/articles/PMC8748196/" target="_blank" rel="noopener noreferrer">Luecken et al., 2022, Nature Methods</a>.
  </p>
</div>

<div class="card focus_card_style">
  <div class="welcome-block-title">What To Specify When You Talk With Bioinformaticians</div>
  <p>
    The goal is not to micromanage. The goal is to make the assumptions visible.
    If the following items are explicit, it becomes much easier to reproduce the analysis, compare reruns, and interpret disagreements:
  </p>
  <ul>
    <li>What matrix is the starting point: Cell Ranger version, reference build, filtered matrix or raw matrix.</li>
    <li>Which cells are removed: minimum genes, minimum UMIs, mitochondrial cutoff, doublet strategy, ambient RNA handling.</li>
    <li>How RNA is normalized: <code>LogNormalize</code> or <code>SCTransform</code>, with key parameters and whether samples are normalized separately or together before later steps.</li>
    <li>How informative genes are chosen: method, number of features, and whether any genes are intentionally excluded.</li>
    <li>Whether integration is done at all, whether it is anchor-based Seurat integration or Harmony-style embedding correction, and what source of variation is being treated as technical.</li>
    <li>Which dimensions and graph settings are used: PC range, neighbors, clustering algorithm, resolution, and random seed.</li>
    <li>How marker genes are called: test, multiple-testing correction, minimum effect size, and whether counts or integrated values are used downstream.</li>
    <li>Exact software versions: Seurat, SeuratObject, dependency versions, and any custom scripts.</li>
  </ul>
  <p>
    When these are left vague, people may think they are discussing the same analysis when they are actually discussing different analyses.
  </p>
</div>

<div class="card">
  <div class="welcome-block-title">What You Can Do In This Pipeline</div>
  <ol>
    <li>Run QC to remove low-quality cells and likely doublets.</li>
    <li>Optionally resolve hashtag labels (HTO/ADT) and integrate V(D)J information.</li>
    <li>Normalize expression and integrate samples to reduce technical effects.</li>
    <li>Generate embeddings and clusters, then annotate clusters with marker genes.</li>
    <li>Export results (including Loupe-compatible outputs when available) and continue downstream analyses.</li>
  </ol>
  <figure class="welcome-tutorial-figure">
    <img class="img-responsive" src="https://cdn.10xgenomics.com/image/upload/v1759183557/software-support/Cell%20Ranger%20ARC/umap.png" alt="10x Cell Ranger ARC UMAP cell clustering dashboard" />
  </figure>
  <p class="welcome-tutorial-citation">
    Reference image: Cell Clustering UMAP panel from <a href="https://www.10xgenomics.com/support/software/cell-ranger-arc/latest/analysis/outputs/web-summary" target="_blank" rel="noopener noreferrer">Cell Ranger ARC Web Summary documentation (10x Genomics)</a>. Image hosted by 10x Genomics.
  </p>
</div>

<div class="card important_card_style">
  <div class="welcome-block-title">Before You Close This Page</div>
  <p>
    This pipeline runs mainly in R, with partial Python support in selected modules. Stability depends on your local environment, package compatibility, and hardware resources.
    Please save your workspace regularly after key milestones. Emergency autosave exists, but manual saving remains the safest strategy.
  </p>
</div>
