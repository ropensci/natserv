PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build . --no-build-vignettes

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples(run = TRUE)"

test:
	${RSCRIPT} -e "devtools::test()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual --no-build-vignettes `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

checkwindows:
	${RSCRIPT} -e "devtools::check_win_devel(quiet = TRUE); devtools::check_win_release(quiet = TRUE)"

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"

vign:
		cd vignettes;\
		${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('natserv.Rmd.og', output = 'natserv.Rmd')";\
		cd ..
