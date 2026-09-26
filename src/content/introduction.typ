#import "../lib.typ": title3

#title3[Introduction]

#html.elem("div", attrs: (class: "prose"))[
  Long-form video understanding encompasses tasks that go beyond retrieving isolated events, including tracking an evolving narrative and interpreting social meaning that may remain implicit.
  However, existing benchmarks rarely evaluate these capabilities jointly, particularly in high-context, non-English media.
  To address this gap, we introduce NARUBench, a benchmark designed to evaluate Narrative evolution and Reasoning on cultural Understanding in Japanese long-form video. NARUBench consists of 1,481 questions grounded in 155 videos totalling 146.8 hours, spanning four narrative and five cultural dimensions.
  To construct the benchmark at this scale, we propose a hierarchical memory-based annotation pipeline that transforms raw video into structured event, narrative, and cultural annotations, then generates questions via task-oriented synthesis and iterative shortcut removal.
  The construction process includes two native-speaker verification stages involving 68 annotators.
  Evaluations across thirteen model configurations reveal substantial limitations in both long-range narrative integration and culturally grounded reasoning.
  By exposing these persistent gaps, NARUBench offers a systematic testing ground for developing MLLMs capable of reliably interpreting long-form, high-context video.
]
