all: vign move rmd2md

vign:
		cd inst/vign;\
		Rscript -e 'library(knitr); knit("natserv_vignette.Rmd")'

move:
		cp inst/vign/natserv_vignette.md vignettes

rmd2md:
		cd vignettes;\
		mv natserv_vignette.md natserv_vignette.Rmd
