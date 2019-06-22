ABOUT
-----

This repository contains supplementary material for the publication:

Antonio Toral. 2019. Post-editese: an Exacerbated Translationese. Machine Translation Summit.


CONTENTS
--------

- **bin/** code to run the experiments (bash, Python and R scripts). The script **runme.sh** runs all the experiments.
- **datasets** the three datasets used in the experiments. They are provided as they are and preprocessed (normalised punctuation and tokenised).
- **results** output of the experiments, in subfolders: length ratio, lexical density, lexical variety, perplexity difference on PoS sequences. Subfolder **tagger-output** contains PoS-tagged data, used for lexical density and perplexity difference.
- **third** third-party code. Moses' scripts are provided. Note that there are two other requirements: UDPipe (1.2.0 was used) and SRILM (1.7.2 was used).

