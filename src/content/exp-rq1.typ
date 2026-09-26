// paper sec. IV-B
#import "../results-table.typ": table-tab

#table-tab(
  [
    #html.elem("p", attrs: (class: "tab-desc"))[
      The table reports multiple-choice accuracy across the full benchmark for thirteen model configurations, broken down into four narrative (N.1–N.4) and five cultural (C.1–C.5) categories with their macro-averages.
      Performance follows a distinct tiering: DeepFrame Platform leads at 78.2% overall, ahead of Gemini-3-Flash at 76.2%, while open-weight models fall into a lower 29.6–39.8% regime.
      Category-level results reveal a capability-dependent split: the leading systems score substantially higher on narrative tasks than on cultural ones, whereas open-weight models show virtually no difference between the two dimensions.
    ]
  ],
  json("../data/results_RQ1.json"),
)
