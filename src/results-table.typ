#let fmt(v, digits) = if digits == 0 { str(calc.round(v)) } else {
  let parts = str(calc.round(v, digits: digits)).split(".")
  let dec = if parts.len() == 1 { "" } else { parts.at(1) }
  parts.at(0) + "." + dec + "0" * (digits - dec.len())
}

// the best value of a column is bolded
// `scale` only affects display; comparisons happen on the raw values
#let num-cell(v, best, digits, scale, cls: none) = {
  let attrs = (:)
  if cls != none { attrs.insert("class", cls) }
  html.elem("td", attrs: attrs, {
    let s = fmt(v * scale, digits)
    if v == best { html.elem("strong", s) } else { s }
  })
}

#let results-table(data, digits: 1, avgs: true, unit: "(%)", scale: 1) = {
  let models = if "totals" in data {
    data.models.map(r => (
      r
        + (
          narrative: if r.at("percent", default: false) {
            r.narrative
          } else {
            r
              .narrative
              .enumerate()
              .map(((i, n)) => n / data.totals.narrative.at(i) * 100)
          },
          cultural: if r.at("percent", default: false) {
            r.cultural
          } else {
            r
              .cultural
              .enumerate()
              .map(((i, n)) => n / data.totals.cultural.at(i) * 100)
          },
        )
    ))
  } else { data.models }

  let rows = models.map(r => {
    let n-avg = r.narrative.sum() / r.narrative.len()
    let c-avg = r.cultural.sum() / r.cultural.len()
    (
      r
        + (
          n-avg: n-avg,
          c-avg: c-avg,
          overall: if avgs { (n-avg + c-avg) / 2 } else {
            (
              (r.narrative.sum() + r.cultural.sum())
                / (r.narrative.len() + r.cultural.len())
            )
          },
        )
    )
  })
  let n-subs = rows.first().narrative.len()
  let c-subs = rows.first().cultural.len()
  let with-unit(label) = if unit == none { label } else { label + " " + unit }

  let best = (
    n: range(n-subs).map(i => calc.max(..rows.map(r => r.narrative.at(i)))),
    n-avg: calc.max(..rows.map(r => r.n-avg)),
    c: range(c-subs).map(i => calc.max(..rows.map(r => r.cultural.at(i)))),
    c-avg: calc.max(..rows.map(r => r.c-avg)),
    overall: calc.max(..rows.map(r => r.overall)),
  )

  // foldable header; expanded by default
  let group-header(label, key, span) = if avgs {
    html.elem(
      "th",
      attrs: (colspan: str(span + 1), data-span: str(span + 1), class: "group"),
      html.elem(
        "button",
        attrs: (
          type: "button",
          class: "expand",
          data-group: key,
          aria-expanded: "true",
        ),
        with-unit(label),
      ),
    )
  } else {
    html.elem(
      "th",
      attrs: (colspan: str(span), class: "group"),
      with-unit(label),
    )
  }

  let table-cls = if avgs { "results show-narrative show-cultural" } else {
    "results"
  }
  html.elem("table", attrs: (class: table-cls), {
    html.elem("thead", {
      html.elem("tr", {
        html.elem("th", attrs: (rowspan: "2", class: "model"), "Model")
        html.elem("th", attrs: (rowspan: "2"), "Sampling")
        group-header("Narrative", "narrative", n-subs)
        group-header("Cultural", "cultural", c-subs)
        html.elem("th", attrs: (rowspan: "2"), with-unit("Overall"))
      })
      html.elem("tr", {
        for i in range(n-subs) {
          html.elem(
            "th",
            attrs: if avgs { (class: "sub g-narrative") } else { (:) },
            "N." + str(i + 1),
          )
        }
        if avgs { html.elem("th", attrs: (class: "avg"), "Avg.") }
        for i in range(c-subs) {
          html.elem(
            "th",
            attrs: if avgs { (class: "sub g-cultural") } else { (:) },
            "C." + str(i + 1),
          )
        }
        if avgs { html.elem("th", attrs: (class: "avg"), "Avg.") }
      })
    })
    html.elem("tbody", {
      for r in rows {
        html.elem("tr", {
          html.elem("td", attrs: (class: "model"), {
            html.elem("a", attrs: (href: r.href), r.name)
            html.elem("div", attrs: (class: "from"), r.from)
          })
          html.elem("td", r.sampling)
          for (j, v) in r.narrative.enumerate() {
            num-cell(v, best.n.at(j), digits, scale, cls: if avgs {
              "sub g-narrative"
            } else { none })
          }
          if avgs {
            num-cell(
              r.n-avg,
              best.n-avg,
              digits,
              scale,
              cls: "avg avg-narrative",
            )
          }
          for (j, v) in r.cultural.enumerate() {
            num-cell(v, best.c.at(j), digits, scale, cls: if avgs {
              "sub g-cultural"
            } else { none })
          }
          if avgs {
            num-cell(
              r.c-avg,
              best.c-avg,
              digits,
              scale,
              cls: "avg avg-cultural",
            )
          }
          num-cell(r.overall, best.overall, digits, scale)
        })
      }
    })
  })
}

#let table-tab(desc, data, digits: 1, avgs: true, unit: "(%)", scale: 1) = {
  html.elem("div", attrs: (class: "table-scroll"), results-table(
    data,
    digits: digits,
    avgs: avgs,
    unit: unit,
    scale: scale,
  ))
  desc
}
