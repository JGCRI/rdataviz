# Project helper functions for server ------------------------------------------------
# addMising()

#' Add missing data
#'
#' Used to add missing data to input files and customize format
#' @param data dataframe to test and convert
#' @importFrom magrittr %>%
#' @importFrom data.table :=
#' @export
addMissing<-function(data){
  NULL -> year -> aggregate -> scenario -> subRegion -> param -> x -> value

  if(!any(grepl("\\<scenario\\>",names(data),ignore.case = T))){data<-data%>%dplyr::mutate(scenario="scenario")}else{
    data <- data %>% dplyr::rename(!!"scenario" := (names(data)[grepl("\\<scenario\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(scenario=dplyr::case_when(is.na(scenario)~"scenario",TRUE~scenario))}
  if(!any(grepl("\\<scenarios\\>",names(data),ignore.case = T))){}else{
    data <- data %>% dplyr::rename(!!"scenario" := (names(data)[grepl("\\<scenarios\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(scenario=dplyr::case_when(is.na(scenario)~"scenario",TRUE~scenario))}
  if(!any(grepl("\\<subRegion\\>",names(data),ignore.case = T))){data<-data%>%dplyr::mutate(subRegion="subRegion")}else{
    data <- data %>% dplyr::rename(!!"subRegion" := (names(data)[grepl("\\<subRegion\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(subRegion=dplyr::case_when(is.na(subRegion)~"subRegion",TRUE~subRegion))}
  if(!any(grepl("\\<subRegions\\>",names(data),ignore.case = T))){}else{
    data <- data %>% dplyr::rename(!!"subRegion" := (names(data)[grepl("\\<subRegions\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(subRegion=dplyr::case_when(is.na(subRegion)~"subRegion",TRUE~subRegion))}
  if(!any(grepl("\\<param\\>",names(data),ignore.case = T))){data<-data%>%dplyr::mutate(param="param")}else{
    data <- data %>% dplyr::rename(!!"param" := (names(data)[grepl("\\<param\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(param=dplyr::case_when(is.na(param)~"param",TRUE~param))}
  if(!any(grepl("\\<params\\>",names(data),ignore.case = T))){}else{
    data <- data %>% dplyr::rename(!!"param" := (names(data)[grepl("\\<params\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(param=dplyr::case_when(is.na(param)~"param",TRUE~param))}
  if(!any(grepl("\\<value\\>",names(data),ignore.case = T))){stop("Data must have 'value' column.")}else{
    data <- data %>% dplyr::rename(!!"value" := (names(data)[grepl("\\<value\\>",names(data),ignore.case = T)])[1])
    data$value = as.numeric(data$value)
    data<-data%>%dplyr::mutate(value=dplyr::case_when(is.na(value)~0,TRUE~value))}
  if(!any(grepl("\\<values\\>",names(data),ignore.case = T))){}else{
    data <- data %>% dplyr::rename(!!"value" := (names(data)[grepl("\\<values\\>",names(data),ignore.case = T)])[1])
    data$value = as.numeric(data$value)
    data<-data%>%dplyr::mutate(value=dplyr::case_when(is.na(value)~0,TRUE~value))}
  if(!any(grepl("\\<unit\\>",names(data),ignore.case = T))){}else{
    data <- data %>% dplyr::rename(!!"units" := (names(data)[grepl("\\<unit\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(units=dplyr::case_when(is.na(units)~"units",TRUE~units))}
  if(!any(grepl("\\<units\\>",names(data),ignore.case = T))){data<-data%>%dplyr::mutate(units="units")}else{
    data <- data %>% dplyr::rename(!!"units" := (names(data)[grepl("\\<units\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(units=dplyr::case_when(is.na(units)~"units",TRUE~units))}
  if(!"x"%in%names(data)){
    if("year"%in%names(data)){
      data<-data%>%dplyr::mutate(x=year)}else{data<-data%>%dplyr::mutate(x="x")}}
  if(!any(grepl("\\<aggregate\\>",names(data),ignore.case = T))){
    if(is.null(aggregate)){data<-data%>%dplyr::mutate(aggregate="sum")}else{
      data<-data%>%dplyr::mutate(aggregate="sum")}
  }else{
    data <- data %>% dplyr::rename(!!"aggregate" := (names(data)[grepl("\\<aggregate\\>",names(data),ignore.case = T)])[1])
    data<-data%>%dplyr::mutate(aggregate=dplyr::case_when(is.na(aggregate)~"sum",
                                                          TRUE~aggregate))}
  if(!any(grepl("\\<class\\>",names(data),ignore.case = T))){
    if(!any(grepl("\\<class\\>",names(data),ignore.case = T))){
      data<-data%>%dplyr::mutate(class="class")}else{data<-data%>%dplyr::mutate(class=class)}}else{
        data <- data %>% dplyr::rename(!!"class" := (names(data)[grepl("\\<class\\>",names(data),ignore.case = T)])[1])
        data<-data%>%dplyr::mutate(class=dplyr::case_when(is.na(class)~"class",TRUE~class))}

  data <- data %>%
    dplyr::select(scenario,subRegion,param,class,x,aggregate,value)
    return(data)
}


#' parse_zip
#'
#' parse zip files
#' @param file file to unzip
#' @importFrom magrittr %>%
#' @export
parse_zip <- function(file){

  tmpdir <- tempdir()
  setwd(tmpdir)
  zip::unzip(
    file, exdir = tmpdir
  )
  for(i in dir()){
    if (endsWith(i, ".csv")){
      return(utils::read.csv(i) %>% as.data.frame())
    }
  }
}

#' parse_remote
#'
#' parse remote files
#' @param urlfiledata remote file link to parse
#' @importFrom magrittr %>%
#' @export
parse_remote <- function(urlfiledata){
  print(urlfiledata)
  if (tools::file_ext(urlfiledata) == ""){
    if (grepl("./$",urlfiledata)){
      #GCAM
      utils::read.csv(urlfiledata) %>%
        as.data.frame()
    } else if((!grepl("./$",urlfiledata, "/") || !grepl(".zip$",urlfiledata) || !grepl(".csv$",urlfiledata))){
      if (grepl(".zip", urlfiledata, fixed=TRUE)){
        temp <- tempfile()
        utils::download.file(urlfiledata, temp)
        return(parse_zip(temp))
      }else if (grepl(".csv", urlfiledata, fixed=TRUE)){
        return(utils::read.csv(urlfiledata) %>%
                 as.data.frame())
      }
    }
  }else if ((tools::file_ext(urlfiledata) == "zip")){
    temp <- tempfile()
    utils::download.file(urlfiledata, temp)
    return(parse_zip(temp))
  }else if (tools::file_ext(urlfiledata) == "csv"){
    temp <- tempfile()
    utils::download.file(urlfiledata, temp)
    return(utils::read.csv(temp) %>%
             as.data.frame())
  }
  else{
    return(NULL)
  }
}


#' parse_local
#'
#' parse local files
#' @param inputdatapath local file to parse
#' @param urlfiledatadatapath local file to parse
#' @importFrom magrittr %>%
#' @export
parse_local <- function(inputdatapath, urlfiledatadatapath){
  print(inputdatapath)
  if (tools::file_ext(inputdatapath) == ""){
    if (grepl("./$",urlfiledatadatapath)){
      utils::read.csv(inputdatapath) %>%
        as.data.frame()
    }
  }else if (tools::file_ext(inputdatapath) == "zip"){
    return(parse_zip(inputdatapath))
  }else if (tools::file_ext(inputdatapath) == "csv"){
    return(utils::read.csv(inputdatapath) %>%
             as.data.frame())
  }else{
    return(NULL)
  }
}

#' exportHeight
#'
#' generate height for exported images
#' @param chartsperrow number of columns
#' @param max_height_in max height
#' @param numelement number of planned elements
#' @param lenperchart height per element
#' @importFrom magrittr %>%
#' @export
exportHeight<-function(chartsperrow,
                       max_height_in,
                       numelement,
                       lenperchart){
  if (numelement%%chartsperrow==0){
    return(min(max_height_in, ((numelement%/%chartsperrow))*lenperchart))
  }else{
    return(min(max_height_in, ((numelement%/%chartsperrow)+1)*lenperchart))
  }
}

#' exportWidth
#'
#' generate width for exported images
#' @param max_width_in max width
#' @param numelement number of planned elements
#' @param lenperchart height per element
#' @importFrom magrittr %>%
#' @export
exportWidth<-function(max_width_in, numelement, lenperchart){
  return(min(max_width_in, (numelement)*lenperchart))
}



#' summaryPlotReg
#'
#' generate summary plot
#' @param titletext plot title
#' @param dataMapx Input map dataframe
#' @param ggplottheme ggplot theme to use
#' @param subsetRegionsx Subset of regions
#' @importFrom magrittr %>%
#' @import ggplot2
#' @export

summaryPlotReg <- function(titletext,
                           dataMapx,
                           ggplottheme,
                           subsetRegionsx){

  # Initialize
 NULL-> param->scenario->subRegion->value->x

  dataChartPlot <- # All regions
    dataMapx %>% tidyr::complete(scenario,param,subRegion,x) %>%
    dplyr::mutate(value= dplyr::case_when(is.na(value)~0,
                                          TRUE~value)) %>%
    dplyr::filter(subRegion %in% subsetRegionsx)

  plist <- list()
  for(i in 1:length(unique(dataChartPlot$param))){

    plist[[i]] <-  ggplot2::ggplot(dataChartPlot %>%
                                     dplyr::filter(param==unique(dataChartPlot$param)[i]),
                                   aes(x=x,y=value,
                                       group=scenario,
                                       color=scenario)) +
      ggplottheme +
      ylab(NULL) + xlab(NULL) +
      geom_line(size=2) +
      scale_y_continuous(position = "right")+
      facet_grid(param~subRegion, scales="free",switch="y",
                 labeller = labeller(param = label_wrap_gen(15))
      )+
      theme(legend.position="top",
            legend.justification='left',
            text = element_text(size = 15),
            legend.title = element_blank(),
            plot.margin=margin(10,10,10,10,"pt"))}

  cowplot::plot_grid(plotlist=plist,ncol=1,align = "v")
}



#' breaks
#'
#' returns breaks generated using k-mean and pretty
#' @param dataMap_raw_param Input dataframe
#' @param breaks_n Number of breaks
#' @importFrom magrittr %>%
#' @import ggplot2
#' @export

breaks <- function(dataMap_raw_param = NULL,
                   breaks_n = 7){

  breaks_pretty <- scales::pretty_breaks(n=breaks_n)(dataMap_raw_param$value); breaks_pretty
  breaks_kmean <- sort(as.vector((stats::kmeans(dataMap_raw_param$value,
                                                centers=max(1,
                                                            min(length(unique(dataMap_raw_param$value))-1,
                                                                (breaks_n-1)))))$centers[,1]));breaks_kmean
  if((max(range(dataMap_raw_param$value))-min(range(dataMap_raw_param$value)))<1E-10 &
     (max(range(dataMap_raw_param$value))-min(range(dataMap_raw_param$value)))>-1E-10){valueRange=floor(min(dataMap_raw_param$value))}else{
       valueRange=range(dataMap_raw_param$value)
     }
  breaks_kmean

  if(abs(min(valueRange,na.rm = T))==abs(max(valueRange,na.rm = T))){valueRange=abs(min(valueRange,na.rm = T))}
  if(mean(valueRange,na.rm = T)<0.01 & mean(valueRange,na.rm = T)>(-0.01)){animLegendDigits<-5}else{
    if(mean(valueRange,na.rm = T)<0.1 & mean(valueRange,na.rm = T)>(-0.1)){animLegendDigits<-4}else{
      if(mean(valueRange,na.rm = T)<1 & mean(valueRange,na.rm = T)>(-1)){animLegendDigits<-3}else{
        if(mean(valueRange,na.rm = T)<10 & mean(valueRange,na.rm = T)>(-10)){animLegendDigits<-2}else{animLegendDigits<-2}}}}
  animLegendDigits
  breaks_kmean <- signif(breaks_kmean,animLegendDigits); breaks_kmean

  if(!min(dataMap_raw_param$value) %in% breaks_kmean){
    breaks_kmean <- sort(c(breaks_kmean,signif(floor(min(dataMap_raw_param$value)))))};breaks_kmean
  if(!max(dataMap_raw_param$value) %in% breaks_kmean){
    breaks_kmean <- sort(c(breaks_kmean,signif(ceiling(max(dataMap_raw_param$value)))))};breaks_kmean


  return(list(breaks_kmean, breaks_pretty))
}


#' summaryPlot
#'
#' generate summary plot
#' @param aspectratio aspect ratio
#' @param textsize text size
#' @param titletext title text
#' @param dataSumx dataSumx()
#' @importFrom magrittr %>%
#' @export
summaryPlot <- function(aspectratio,
                        textsize,
                        titletext,
                        dataSumx){
  NULL->x->value->scenario->ggplottheme
  ggplot2::ggplot(dataSumx,
                  aes(x=x,y=value,
                      group=scenario,
                      color=scenario))+
    ggplottheme +
    geom_line(size=2) +
    ylab(NULL) +  xlab(NULL) +
    facet_wrap(.~param, scales="free", ncol = 3,
               labeller = labeller(param = label_wrap_gen(15)))+
    theme(legend.position="top",
          legend.title = element_blank(),
          plot.margin=margin(20,20,20,0,"pt"),
          text=element_text(size=textsize),
          aspect.ratio = aspectratio
    )
}


#' plotDiff
#'
#' generate chart plot for absolute difference and percent difference
#' @param dataChartPlot dataChartPlot: dataDiffAbsx() or dataPrcntDiffx()
#' @param scenarioRefSelected scenarioRefSeleceted
#' @importFrom magrittr %>%
#' @export
plotDiffAbs<- function(dataChartPlot, scenarioRefSelected){

  NULL -> filter -> param -> scenario -> input -> value

  g <- 2

  plist <- list()
  x = 1

  for(i in 1:length(unique(dataChartPlot$param))){

    dataChartPlot <- dataChartPlot %>%
      dplyr::filter(!(is.na(class) & value==0))%>%
      dplyr::mutate(class=dplyr::if_else(is.na(class),"NA",class))

    # Check Color Palettes
    palAdd <- rep(c("firebrick3","dodgerblue3","forestgreen","black","darkgoldenrod3","darkorchid3","gray50", "darkturquoise"),1000)

    missNames <- unique(dataChartPlot$class)[!unique(dataChartPlot$class) %in%
                                               names(jgcricolors::jgcricol()$pal_all)]
    if (length(missNames) > 0) {
      palAdd <- palAdd[1:length(missNames)]
      names(palAdd) <- missNames
      palCharts <- c(jgcricolors::jgcricol()$pal_all, palAdd)
    } else{
      palCharts <- jgcricolors::jgcricol()$pal_all
    }

    chartz <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario == scenarioRefSelected)
    z<-x

    temp <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario != scenarioRefSelected)%>%
      droplevels()

    palCharts <- palCharts[names(palCharts) %in% unique(temp$class)]

    plist[[z+1]] <-  ggplot2::ggplot(dataChartPlot %>%
                                       dplyr::filter(param==unique(dataChartPlot$param)[i], scenario != scenarioRefSelected)%>%
                                       droplevels(),
                                     aes(x=x,y=value,
                                         group=class,
                                         fill=class))+
      ggplot2::theme_bw() +
      xlab(NULL) +
      ylab(NULL) +
      scale_fill_manual(breaks=names(palCharts),values=palCharts) +
      scale_y_continuous(position = "left")+
      geom_bar(position="stack", stat="identity") +
      facet_grid(param~scenario, scales="free",switch="y") +
      theme(legend.position="bottom",
            legend.title = element_blank(),
            strip.text.y = element_blank(),
            legend.margin=margin(0,0,0,0,"pt"),
            legend.key.height=unit(0, "cm"),
            text = element_text(size = 15),
            plot.margin=margin(20,20,20,0,"pt"))
    x = x+2


    plist[[z]] <-  ggplot2::ggplot(chartz%>%
                                     droplevels(),
                                   aes(x=x,y=value,
                                       group=class,
                                       fill=class))+
      ggplot2::theme_bw()  +
      xlab(NULL) +
      ylab(unique(dataChartPlot$param)[i])+
      scale_fill_manual(breaks=names(palCharts),values=palCharts) +
      scale_y_continuous(position = "left")+
      geom_bar(position="stack", stat="identity") +
      facet_grid(param~scenario, scales="free",switch="y")+
      theme(legend.position="bottom",
            strip.text.y = element_blank(),
            legend.title = element_blank(),
            legend.margin=margin(0,0,0,0,"pt"),
            legend.key.height=unit(0, "cm"),
            text = element_text(size = 15),
            plot.margin=margin(20,0,20,0,"pt"))
  }
  cowplot::plot_grid(plotlist = plist, ncol=g, align="v", rel_widths = c(1, length(unique(dataChartPlot$scenario))-1))
}

#' plotDiff
#'
#' generate chart plot for absolute difference and percent difference
#' @param dataChartPlot dataChartPlot: dataDiffAbsx() or dataPrcntDiffx()
#' @param scenarioRefSelected scenarioRefSeleceted
#' @importFrom magrittr %>%
#' @export
plotDiffPrcnt<- function(dataChartPlot, scenarioRefSelected){

  NULL -> filter -> param -> scenario -> input -> value

  g <- 2


  plist <- list()
  x = 1

  for(i in 1:length(unique(dataChartPlot$param))){

    dataChartPlot <- dataChartPlot %>%
      dplyr::filter(!(is.na(class) & value==0))%>%
      dplyr::mutate(class=dplyr::if_else(is.na(class),"NA",class))

    # Check Color Palettes
    palAdd <- rep(c("firebrick3","dodgerblue3","forestgreen","black","darkgoldenrod3","darkorchid3","gray50", "darkturquoise"),1000)

    missNames <- unique(dataChartPlot$class)[!unique(dataChartPlot$class) %in%
                                               names(jgcricolors::jgcricol()$pal_all)]
    if (length(missNames) > 0) {
      palAdd <- palAdd[1:length(missNames)]
      names(palAdd) <- missNames
      palCharts <- c(jgcricolors::jgcricol()$pal_all, palAdd)
    } else{
      palCharts <- jgcricolors::jgcricol()$pal_all
    }

    chartz <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario == scenarioRefSelected)
    z<-x

    temp <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario != scenarioRefSelected)%>%
      droplevels()

    palCharts <- palCharts[names(palCharts) %in% unique(temp$class)]

    plist[[z+1]] <-  ggplot2::ggplot(dataChartPlot %>%
                                       dplyr::filter(param==unique(dataChartPlot$param)[i], scenario != scenarioRefSelected)%>%
                                       droplevels(),
                                     aes(x=x,y=value,
                                         group=class,
                                         color=class))+
      ggplot2::theme_bw() +
      xlab(NULL) +
      ylab(NULL) +
      scale_color_manual(breaks=names(palCharts),values=palCharts) +
      scale_y_continuous(position = "left")+
      geom_line(size=2)+
      facet_grid(param~scenario, scales="free",switch="y") +
      theme(legend.position="bottom",
            legend.title = element_blank(),
            strip.text.y = element_blank(),
            legend.margin=margin(0,0,0,0,"pt"),
            legend.key.height=unit(0, "cm"),
            text = element_text(size = 15),
            plot.margin=margin(20,20,20,0,"pt"))
    x = x+2


    plist[[z]] <-  ggplot2::ggplot(chartz%>%
                                     droplevels(),
                                   aes(x=x,y=value,
                                       group=class,
                                       fill=class))+
      ggplot2::theme_bw()  +
      xlab(NULL) +
      ylab(unique(dataChartPlot$param)[i])+
      scale_fill_manual(breaks=names(palCharts),values=palCharts) +
      scale_y_continuous(position = "left")+
      geom_bar(position="stack", stat="identity") +
      facet_grid(param~scenario, scales="free",switch="y")+
      theme(legend.position="bottom",
            strip.text.y = element_blank(),
            legend.title = element_blank(),
            legend.margin=margin(0,0,0,0,"pt"),
            legend.key.height=unit(0, "cm"),
            text = element_text(size = 15),
            plot.margin=margin(20,0,20,0,"pt"))
  }
  cowplot::plot_grid(plotlist = plist, ncol=g, align="v", rel_widths = c(1, length(unique(dataChartPlot$scenario))-1))
}


#' plotAbs
#'
#' generate chart plot for absolute value
#' @param dataChartPlot dataChartPlot: dataChartx()
#' @param scenarioRefSelected scenarioRefSelected
#' @importFrom magrittr %>%
#' @export
plotAbs <- function(dataChartPlot, scenarioRefSelected){

  NULL -> filter -> param -> scenario -> input -> value

  g <- 1

  plist <- list()
  x = 1
  for(i in 1:length(unique(dataChartPlot$param))){

    dataChartPlot <- dataChartPlot %>%
      dplyr::filter(!(is.na(class) & value==0))%>%
      dplyr::mutate(class=dplyr::if_else(is.na(class),"NA",class))

    # Check Color Palettes
    palAdd <- rep(c("firebrick3","dodgerblue3","forestgreen","black","darkgoldenrod3","darkorchid3","gray50", "darkturquoise"),10000)

    missNames <- unique(dataChartPlot$class)[!unique(dataChartPlot$class) %in%
                                               names(jgcricolors::jgcricol()$pal_all)]
    if (length(missNames) > 0) {
      palAdd <- palAdd[1:length(missNames)]
      names(palAdd) <- missNames
      palCharts <- c(jgcricolors::jgcricol()$pal_all, palAdd)
    } else{
      palCharts <- jgcricolors::jgcricol()$pal_all
    }

    chartz <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario == scenarioRefSelected)
    z<-x

    chartz <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i])
    x=x+1

    temp <- dataChartPlot %>%
      dplyr::filter(param==unique(dataChartPlot$param)[i], scenario != scenarioRefSelected)%>%
      droplevels()

    palCharts <- palCharts[names(palCharts) %in% unique(temp$class)]

    plist[[z]] <-  ggplot2::ggplot(chartz%>%
                                     droplevels(),
                                   aes(x=x,y=value,
                                       group=scenario,
                                       fill=class))+
      ggplot2::theme_bw() +
      xlab(NULL) +
      ylab(unique(dataChartPlot$param)[i])+
      scale_fill_manual(breaks=names(palCharts),values=palCharts) +
      scale_y_continuous(position = "left")+
      geom_bar(position="stack", stat="identity") +
      facet_grid(param~scenario, scales="free",switch="y")+
      theme(legend.position="bottom",
            strip.text.y = element_blank(),
            legend.title = element_blank(),
            legend.margin=margin(0,0,0,0,"pt"),
            legend.key.height=unit(0, "cm"),
            text = element_text(size = 15),
            plot.margin=margin(20,0,20,0,"pt"))
  }
  cowplot::plot_grid(plotlist = plist, ncol=g, align="v", rel_widths = c(1, length(unique(dataChartPlot$scenario))-1))
}


