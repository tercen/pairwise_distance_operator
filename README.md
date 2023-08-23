# Pairwise distance operator

##### Description

The `pairwise_distance` operator returns the Relative Mean Squared Deviation computed between pairs of variables.

##### Usage

Input projection|.
---|---
`row`        | factor, input variables used to compute the distance
`col`        | factor, observations 
`.y`        | numeric, measurements

Input parameters|.
---|---
`method`        | factor, any of `euclidian`, `pearson`, `spearman`, `kendall`, `rmsd`, `maximum`, `manhattan`, `canberra`, `binary` or `minkowski`.

Output relations|.
---|---
`dist`        | numeric, distance
`to`        | numeric, variable to be projected against the initial one for pairwise distance visualisation

##### Details

Different distance metrics can be computed: `euclidian`, `rmsd`, `maximum`, `manhattan`, `canberra`, `binary` or `minkowski`.

##### References

Wrapper of the `dist` [R function](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/dist).