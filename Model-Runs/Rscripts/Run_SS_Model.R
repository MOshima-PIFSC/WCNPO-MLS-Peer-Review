### Set up the SS model to run
### Notes about the template input files: you need separate control 
### and data files for single sex models and two-sex models. Otherwise 
### the starter and forecast files can be the same.


## 1. Input needed information
suppressMessages(suppressWarnings(library(r4ss)))
library(ss3diags, quietly=T, warn.conflicts = F)
library(readxl)
library(quarto)
library(googlesheets4)
library(tidyr)
library(dplyr)
library(tibble)
library(stringr)
## base working directory where all files are stored if working on a local directory

base.dir<-"C:/Users/Michelle.Sculley/Documents/WCNPO-MLS-Peer-Review/Model-Runs"

## if working on codespaces:
base.dir<-c("./Model-Runs")

fleetnames<-c("F01_JPNLL_Q1A1_Late",
              "F02_JPNLL_Q1A2",
              "F03_JPNLL_Q1A3",
              "F04_JPNLL_Q2A1",
              "F05_JPNLL_Q3A1_Late",
              "F06_JPNLL_Q4A1",
              "F07_JPNLL_Q1A4",
              "F08_JPNLL_Q2A2",
              "F09_JPNLL_Q3A2",
              "F10_JPNLL_Q4A2",
              "F11_JPNLL_Q4A3",
              "F12_JPNLL_Others",
              "F13_JPNDF_Q14_EarlyLate",
              "F14_JPNDF_Q23_EarlyLate",
              "F15_JPN_Others",
              "F16_US_LL",
              "F17_US_Others",
              "F18_TWN_DWLL",
              "F19_TWN_STLL",
              "F20_TWN_Others",
              "F21_WCPFC_Others",
              "F22_JPNLL_Q1A1_Early",
              "F23_JPNLL_Q3A1_Early",
              "F24_JPNDF_Q14_Mid",
              "F25_JPNDF_Q23_Mid",
              "S01_JPNLL_Q1A1_Late",
              "S02_JPNLL_Q3A1_Late",
              "S03_US_LL",
              "S04_TWN_DWLL",
              "S05_JPNLL_Q1A1_Early",
              "S06_JPNLL_Q3A1_Early")




model.info<-list(
  "base.dir"=base.dir,
  "startyear"=1977,
  "endyear"=2020,
  "nyr"=20,  ## indicates how many years you want to average the dynamic B0 over if applicable
  "nboot"= 100, ## number of bootstrap files to create
  "seed"=123, ##set seed value
  "data.file.name"="base-final.dat",
  "ctl.file.name"="base-final.ctl",
  "templatefiles"=list("data"="data.dat",
                       "control"="control.ctl"),
  "template_dir" = file.path(base.dir,"Template_files"),
  "out_dir"="Base",
  "N_foreyrs"= -1,
  "F_age_range"=c(3,12),
  "F_report_basis" = 0, #0=raw_annual_F; 1=F/Fspr; 2=F/Fmsy; 3=F/Fbtgt; where F means annual_F; values >=11 invoke N multiyr (up to 9!) with 10's digit; >100 invokes log(ratio)
  "Min_age_biomass"=1,
  "Nfleets"=31,  ##this is total number of fleets, including survey, etc.
  "Nsurvey"=6,
  "Nsexes" = 1,
  "Species"="MLS",
  "fleets"=fleetnames,
  "catch.file"="InputCatch_Base.csv",
  "length.file"="InputLength_Base.csv",
  "CPUE.file"="InputCPUE_Base.csv",
  "scenario"="base",
  "binwidth"=5,
  "bin.min"=50,
  "bin.max"=230,
  "fleetinfo.special"=NULL, #fleet number, special survey type (otherthan  1 - catch or 3 - CPUE/Survey )
  "catch.num"=c(1:11,22:31),  ##fleets in which catch is in numbers,
  "nseas"=4,
  "spawn_month"=6,
  "lbin_method"=2,
  "lambdas"=TRUE)


## Run models
source(file.path(base.dir,"Rscripts","SS Runs","01_Build_All_SS.R"))
Build_All_SS(model.info=model.info,
             species_folder=FALSE,
             M_option = "Base",
             GROWTH_option = "Base",
             LW_option = "Base",
             MAT_option = "Base",
             SR_option = "Base",
             EST_option = "Base",
             initF = TRUE,
             includeCPUE = TRUE,
             superyear = FALSE,
             superyear_blocks = NULL,
             N_samp = 40,
             init_values = 0, 
             parmtrace = 0,
             last_est_phs = 10,
             benchmarks = 1,
             MSY = 2,
             SPR.target = 0.2,
             Btarget = 0.19,
             Bmark_years = c(0,0,0,0,0,0,1994,2020,1994,2020),
             Bmark_relF_Basis = 1,
             Forecast = -2,
             Fcast_years = c(0,0,0,0,0,0),
             Fixed_forecatch=1,
             ControlRule = 0,
             write_files = TRUE,
             runmodels =TRUE,
             ext_args = "",  ## -nohess to run without hessian
             do_retro = FALSE,
             retro_years = 0:-5,
             do_profile = FALSE,
             profile_name = "SR_LN(R0)",
             profile.vec = c(4, 0.1),
             do_jitter = FALSE,
             Njitter = 10,
             jitterFraction = 0.1,
             do_ASPM = FALSE,
             printreport = FALSE,
             r4ssplots = FALSE,
             readGoogle = FALSE,
             run_parallel=TRUE,
             exe="ss_opt_linux"  ## note, for linux (codespaces) use ss_opt_linux, for mac use ss_opt_osx, for windows use ss.exe
)
