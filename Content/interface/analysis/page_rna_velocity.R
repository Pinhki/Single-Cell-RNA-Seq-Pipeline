RNA_VELOCITY_UI_TEXT <- list(
  ui_title_main = "RNA Velocity (Guidance Only)",
  ui_text_main_description = "This page does not run RNA velocity yet. Use it as a checklist before handing off files for velocyto/scVelo analysis.",
  ui_label_guidance_only = "Guidance only: no in-app RNA velocity execution in this version.",
  ui_card_title_step1 = "1. Finish Basic Analysis First",
  ui_card_text_step1 = "Complete the current pipeline through QC and main analysis so UMAP/clusters and metadata are stable before velocity handoff.",
  ui_card_title_step2 = "2. Locate Matching FASTQ Files",
  ui_card_text_step2 = "RNA velocity requires raw sequencing inputs (or equivalent BAM) to derive spliced and unspliced counts. Filtered 10x matrices alone are not sufficient.",
  ui_card_title_step3 = "3. Estimate RAM for Velocyto .loom Generation (Server Purchasing Guide)",
  ui_table_col_bam = "BAM size range",
  ui_table_col_cells = "Approximate cell count range",
  ui_table_col_ram = "Recommended RAM",
  ui_table_col_risk = "Risk level",
  ui_table_col_buy = "Practical buying recommendation",
  ui_row1_bam = "<= 20 GB",
  ui_row1_cells = "<= 20k",
  ui_row1_ram = "32 GB",
  ui_row1_risk = "Low-Medium",
  ui_row1_buy = "Entry tier only. Buy 64 GB if growth or multi-sample batches are likely.",
  ui_row2_bam = "20-50 GB",
  ui_row2_cells = "20k-60k",
  ui_row2_ram = "64 GB",
  ui_row2_risk = "Medium",
  ui_row2_buy = "If workload is near upper bound, buy 128 GB instead of targeting 64 GB minimum.",
  ui_row3_bam = "50-90 GB",
  ui_row3_cells = "60k-120k",
  ui_row3_ram = "96 GB",
  ui_row3_risk = "Medium-High",
  ui_row3_buy = "96 GB is workable; 128 GB is preferred for safer throughput and fewer memory stalls.",
  ui_row4_bam = "90-150 GB",
  ui_row4_cells = "120k-220k",
  ui_row4_ram = "128 GB",
  ui_row4_risk = "High",
  ui_row4_buy = "If workload is borderline for 128 GB, buy 256 GB to avoid reruns and queue delays.",
  ui_row5_bam = ">= 150 GB",
  ui_row5_cells = ">= 220k",
  ui_row5_ram = "256 GB",
  ui_row5_risk = "Very High",
  ui_row5_buy = "Use 256 GB as baseline purchase tier for large/deep datasets and aggressive parallel settings.",
  ui_note_heuristic = "Heuristic planning table only; not a strict guarantee.",
  ui_note1 = "Cell count alone is insufficient for server sizing.",
  ui_note2 = "BAM size, sequencing depth, duplicate reads, annotation complexity, and parallel settings can all change memory usage.",
  ui_note3 = "Buy with headroom rather than targeting the minimum.",
  ui_buyer_bullet1 = "Use BAM size as the primary sizing signal; treat cell count as a secondary check.",
  ui_buyer_bullet2 = "When workload is near a RAM tier boundary, purchase the next tier to reduce operational risk.",
  ui_buyer_bullet3 = "For procurement, prioritize stable completion under peak runs over minimum-fit configurations.",
  ui_buyer_bullet4 = "If future sample volume is uncertain, choose capacity that covers at least one tier above current estimates.",
  ui_card_title_step4 = "4. Continue to .loom Velocity Workflow (alpha)",
  ui_card_text_step4 = "When your .loom file is ready, open the in-app RNA velocity workflow page and run velocity directly in the pipeline.",
  ui_loom_link_title = "Next action",
  ui_loom_link_bullet1 = "Prepare a valid .loom file that matches your active Seurat object barcode naming.",
  ui_loom_link_bullet2 = "Open the hidden RNA velocity v0.5.2 page from admin mode.",
  ui_loom_link_bullet3 = "Upload .loom, run velocity, review plots, and optionally write metadata back to the active object.",
  ui_loom_link_btn = "Open .loom RNA Velocity Page (alpha)"
)

rna_velocity_ui <- fluidPage(
  class = "plotting-page",
  tags$head(
    tags$style(HTML("
      .rv-page-wrap { width: 100%; max-width: none; margin: 0; }
      .rv-pill {
        display: inline-block;
        background: #fffbeb;
        color: #92400e;
        border: 1px solid #fcd34d;
        border-radius: 999px;
        padding: 5px 12px;
        font-size: 0.9rem;
        font-weight: 600;
        margin-top: 8px;
      }
      .rv-card-title {
        font-weight: 700;
        font-size: 1.06rem;
        margin-bottom: 8px;
      }
      .rv-muted { color: #4b5563; margin-bottom: 0; }
      .rv-grid-gap { margin-top: 2px; }
      .rv-mini-title {
        font-weight: 700;
        margin-bottom: 4px;
      }
      .rv-checklist { margin-bottom: 0; }
      .rv-bullet {
        list-style: disc;
        margin: 0;
        padding-left: 1.2rem;
        color: #1f2937;
      }
      .rv-checklist-title {
        font-size: 0.9rem;
        font-weight: 700;
        color: #374151;
        margin: 4px 0 8px 0;
        text-transform: uppercase;
        letter-spacing: 0.02em;
      }
      .rv-panel-card {
        box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      }
      .rv-hero-layout {
        display: grid;
        grid-template-columns: 1.25fr 0.75fr;
        gap: 12px;
        align-items: start;
      }
      .rv-demo {
        border: 1px solid #d8dee6;
        border-radius: 12px;
        background: #f8fafc;
        overflow: hidden;
        max-width: 320px;
        justify-self: end;
      }
      .rv-demo img {
        display: block;
        width: 100%;
        height: auto;
      }
      .rv-demo-caption {
        padding: 7px 9px;
        border-top: 1px solid #e5e7eb;
        background: #ffffff;
        color: #4b5563;
        font-size: 0.74rem;
        line-height: 1.25;
      }
      .rv-hw-card .rv-mini-title {
        font-size: 1rem;
        margin-bottom: 8px;
      }
      .rv-table-wrap {
        width: 100%;
        overflow-x: auto;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        background: #ffffff;
      }
      .rv-table {
        width: 100%;
        min-width: 860px;
        border-collapse: collapse;
        color: #1f2937;
      }
      .rv-table th,
      .rv-table td {
        padding: 10px 12px;
        border-bottom: 1px solid #e5e7eb;
        text-align: left;
        vertical-align: top;
        font-size: 0.9rem;
      }
      .rv-table th {
        background: #f8fafc;
        font-weight: 700;
        white-space: nowrap;
      }
      .rv-table tr:last-child td {
        border-bottom: none;
      }
      .rv-note-box {
        margin-top: 10px;
        border: 1px solid #dbeafe;
        background: #f8fbff;
        border-radius: 8px;
        padding: 9px 10px;
        color: #1e3a8a;
        font-size: 0.88rem;
      }
      @media (max-width: 768px) {
        .rv-page-wrap .card { margin: 12px 0; padding: 16px; }
        .rv-hero-layout { grid-template-columns: 1fr; }
        .rv-demo { max-width: 100%; justify-self: stretch; }
      }
    "))
  ),
  div(
      class = "rv-page-wrap",
      div(
      class = "card env-hero-card rv-panel-card",
      div(
        class = "rv-hero-layout",
        div(
          h2(icon("line-chart"), " ", RNA_VELOCITY_UI_TEXT$ui_title_main),
          p(class = "env-hero-note", RNA_VELOCITY_UI_TEXT$ui_text_main_description),
          div(class = "rv-pill", RNA_VELOCITY_UI_TEXT$ui_label_guidance_only)
        ),
        div(
          class = "rv-demo",
          tags$img(src = "images/rna_velocity_intro_scvelo.png", alt = "RNA velocity introduction figure"),
          div(class = "rv-demo-caption", HTML("General RNA velocity introduction figure. Source: scVelo tutorials (<a href='https://scvelo.readthedocs.io/en/stable/VelocityBasics.html' target='_blank' rel='noopener noreferrer'>Velocity Basics</a>)."))
        )
      )
    ),

    fluidRow(
      class = "rv-grid-gap",
      column(
        width = 12,
        div(
          class = "card env-select-card rv-panel-card",
          div(class = "rv-card-title", icon("circle-check"), " ", RNA_VELOCITY_UI_TEXT$ui_card_title_step1),
          tags$ul(
            class = "rv-bullet",
            tags$li(RNA_VELOCITY_UI_TEXT$ui_card_text_step1)
          )
        )
      ),
      column(
        width = 12,
        div(
          class = "card env-select-card rv-panel-card",
          div(class = "rv-card-title", icon("database"), " ", RNA_VELOCITY_UI_TEXT$ui_card_title_step2),
          tags$ul(
            class = "rv-bullet",
            tags$li(RNA_VELOCITY_UI_TEXT$ui_card_text_step2)
          )
        )
      ),
      column(
        width = 12,
        div(
          class = "card env-select-card rv-panel-card",
          div(class = "rv-card-title", icon("server"), " ", RNA_VELOCITY_UI_TEXT$ui_card_title_step3),
          div(
            class = "rv-table-wrap",
            tags$table(
              class = "rv-table",
              tags$thead(
                tags$tr(
                  tags$th(RNA_VELOCITY_UI_TEXT$ui_table_col_bam),
                  tags$th(RNA_VELOCITY_UI_TEXT$ui_table_col_cells),
                  tags$th(RNA_VELOCITY_UI_TEXT$ui_table_col_ram),
                  tags$th(RNA_VELOCITY_UI_TEXT$ui_table_col_risk),
                  tags$th(RNA_VELOCITY_UI_TEXT$ui_table_col_buy)
                )
              ),
              tags$tbody(
                tags$tr(
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row1_bam),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row1_cells),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row1_ram),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row1_risk),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row1_buy)
                ),
                tags$tr(
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row2_bam),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row2_cells),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row2_ram),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row2_risk),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row2_buy)
                ),
                tags$tr(
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row3_bam),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row3_cells),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row3_ram),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row3_risk),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row3_buy)
                ),
                tags$tr(
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row4_bam),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row4_cells),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row4_ram),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row4_risk),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row4_buy)
                ),
                tags$tr(
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row5_bam),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row5_cells),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row5_ram),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row5_risk),
                  tags$td(RNA_VELOCITY_UI_TEXT$ui_row5_buy)
                )
              )
            )
          ),
          div(
            class = "rv-note-box",
            strong(RNA_VELOCITY_UI_TEXT$ui_note_heuristic),
            tags$ul(
              class = "rv-bullet",
              tags$li(RNA_VELOCITY_UI_TEXT$ui_note1),
              tags$li(RNA_VELOCITY_UI_TEXT$ui_note2),
              tags$li(RNA_VELOCITY_UI_TEXT$ui_note3)
            )
          ),
          tags$ul(
            class = "rv-bullet",
            tags$li(RNA_VELOCITY_UI_TEXT$ui_buyer_bullet1),
            tags$li(RNA_VELOCITY_UI_TEXT$ui_buyer_bullet2),
            tags$li(RNA_VELOCITY_UI_TEXT$ui_buyer_bullet3),
            tags$li(RNA_VELOCITY_UI_TEXT$ui_buyer_bullet4)
          )
        )
      )
    ),

    div(
      class = "card env-select-card rv-panel-card",
      div(class = "rv-card-title", icon("route"), " ", RNA_VELOCITY_UI_TEXT$ui_card_title_step4),
      p(class = "rv-muted", RNA_VELOCITY_UI_TEXT$ui_card_text_step4),
      div(class = "rv-checklist-title", icon("list-check"), " ", RNA_VELOCITY_UI_TEXT$ui_loom_link_title),
      tags$ul(
        class = "rv-bullet rv-checklist",
        tags$li(RNA_VELOCITY_UI_TEXT$ui_loom_link_bullet1),
        tags$li(RNA_VELOCITY_UI_TEXT$ui_loom_link_bullet2),
        tags$li(RNA_VELOCITY_UI_TEXT$ui_loom_link_bullet3)
      ),
      div(style = "margin-top: 10px;"),
      actionButton(
        inputId = "rv_guidance_open_loom_btn",
        label = RNA_VELOCITY_UI_TEXT$ui_loom_link_btn,
        icon = icon("arrow-right"),
        class = "btn btn-primary btn-sm"
      )
    )
  )
)
