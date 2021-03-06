library(shiny) 
library(shinythemes)
library(rhandsontable)
library(gridExtra)
library(ggplot2)
#library(markdown)
#library(knitr)
##source("helpers.R")
# 
# load("data/quant1.RData")
# load("data/quant2.RData")
# load("data/cat1quant1/.RData")

  ##  User should choose a variable type, then 
    ## load Data  and
    ## describe, test, or estimate

  ## Load 'spreadsheet' data using:
  ## https://github.com/jrowen/rhandsontable/blob/master/inst/examples/shiny.R

shinyUI(navbarPage("Intro Stat Apps", id="top-nav", collapsible=TRUE,
                    theme = shinytheme("spacelab"),
    ## 
    ## use empty tabPanel to avoid printing "tab-pane active"               
    tabPanel(""), 
    
    ####   One Categorical  -----------------------------------------------------   1 cat
{
    navbarMenu("One Categ.",  
       tabPanel("Enter / Describe Data", label="1catDataEntry",       
                h5(textOutput('cat1DataIn')),
                ##  Input counts and labels         
                br(),    
                fluidRow(
                  column(5,  div( label = "cat1Input", height = "300px",
                                  tags$label('Category 1: ', 
                                             tags$input(name='cat1_name1', type='text', value='Success', size='10')),
                                  tags$label('Count: ',
                                             tags$input(name='cat1_n1', type='text', value='0', size='5')),
                                  br(),
                                  tags$label('Category 2: ', 
                                             tags$input(name='cat1_name2', type='text', value='Failure', size='10')),
                                  tags$label('Count: ', 
                                             tags$input(name='cat1_n2', type='text', value='0', size='5')),
                                  HTML("&nbsp; &nbsp;"),
                                  actionButton("cat1_submitButton", "Use These Data", inverse = FALSE)
                                  )),
                  column(3, plotOutput('cat1_Plot',width="80%")),
                  column(3, tableOutput("cat1_Summary"))       
                  )
                ),
    tabPanel("Test", value="cat1_Test",
                uiOutput('cat1_testUI') 
    ),
    tabPanel("Estimate", value="cat1_Estimate",
             uiOutput('cat1_estimateUI')
    ),
   tabPanel("Confidence Interval Demo", value = "cat1_CIdemo",
            titlePanel("Demo to Illustrate the meaning of 'Confidence' in an Interval"),
            fluidRow(
                  column(4, 
                         sliderInput("CIdemo_n", "Sample Size (number of spins)", min = 21, max = 100, value = 50),
                         uiOutput("inputTrueP"),
                    radioButtons("CIdemo_reps", label="Number of simulations", choices = list('10', '100', '1000','10000'), selected = '100', inline = TRUE),
                    ## h5("Choose a confidence level"),
                     radioButtons("CIdemo_conf", label="Choose a Confidence Level", choices = list('80%', '90%', '95%', '99%'), 
                                  selected = '90%', inline = TRUE) 
                    ), 
                
                fluidRow(
                    ##  next two need to be action buttons so we can keep using the same sample.
                    #h5("Choose a confidence level"),
                    # radioButtons("CIdemo_conf", label="Confidence Level", choices = list('80%', '90%', '95%', '99%'), 
                    #              selected = '90%', inline = TRUE) 
                    #),  
                    column(7, #div( ## style="height: 300px",
                      h4("Sampling Distribution.  Click a point to see CI.", center = TRUE),
                      plotOutput("CIdemo_Plot1",  click = "CIplot1_click")
                    )),
                
                fluidRow(
                  column(7, offset=4,
                     h4("Confidence Intervals  (green ones cover true p)", center =TRUE),
                     plotOutput("CIdemo_Plot2")
                   )
                )
         )
         ),
         tabPanel("Lurking Demo", value="1catLurk",
            h3("What does Randomization do to a LURKing Variable?"),
            h4("Choose Sample sizes"),
            uiOutput('c1_LurkDataUI'),
            uiOutput('c1_LurkingUI')        
          ),
   
        tabPanel("Normal Distribution" , value="cat1_Normal",
                 titlePanel("Normal Probabilities"),
                 column(3, inputPanel(
                   #helpText("Either enter  "),
                   textInput('cat1_z_txt', label='Standardized Value: ', value=" "),
                   #helpText("Or "),
                   textInput('cat1_prob_txt', 'or  Probability: ', " "),
                   selectInput("cat1_area", "Which area? ", 
                               c("Lower","Upper","Extremes","Center"), NA)
                   ##selectInput("cat1_dist", "Distribution: ",c("Normal"), "Normal")
                 )),   
                 column(9,
                        plotOutput('normalProbPlot1')
                 )  #,
                 #h6("Normal Approx")
       )
    )
}   ,
    ####   One Quantitative  ----------------------------------------------------  1 Quant
{
    navbarMenu("One Quant.",
      tabPanel("Enter /Describe Data", value="1quantDataEntry",
                 ##  preloaded data  - save as data/quant1.RData
                 ##  read local csv file
                 ##  open empty table to copy or type in data.
                 ##
               ##  Existing data is stored in "data/quant1.RData"
               h4(textOutput('quant1DataIn')),
               fluidRow(  
                 column(6, selectInput('q1_entry', ' ', 
                                      list(" ", "Pre-Loaded Data","Local CSV File","Type/Paste into Data Table"), 
                                      selected = " ",
                                      selectize = FALSE))
               ),
               
               ## Need to use Dynamic UI instead of condition panels
               
               uiOutput("q1_inputUI"),
      
               hr(),
               fluidRow(
                 column(8, 
                       plotOutput('q1_Plot') ),
                 column(3, 
                       tableOutput('q1_Summary'))
               )
      ),
      tabPanel("Test", value="1quantTest",
           uiOutput('q1_testUI') 
      ),
      tabPanel("Estimate", value="1quantEstimate",
        uiOutput('q1_estimateUI')
      ),
      tabPanel("Bootstrap Demo", value="1quantBoot",
        a(href="http://www.math.montana.edu/~jimrc/randomization/BootDemo.html","Click to see Bootstrap Demo") 
      ),
      tabPanel("Lurking Demo", value="1quantLurk",
               h3("What does Randomization do to a LURKing Variable?"),
               h4("Choose a data type for this demo, random data will be generated."),
               uiOutput('q1_LurkDataUI'),
               uiOutput('q1_LurkingUI')        
      ),
      tabPanel("t Distribution",  value="1quantT",
               titlePanel("t Probabilities"),
               column(4, inputPanel(
                 #helpText("Either enter  "),
                 textInput('q1_z_txt', label='Standardized Value: ', value=" "),
                 #helpText("Or "),
                 textInput('q1_prob_txt', 'or  Probability: ', " "),
                 selectInput("q1_area", "To go into which area? ", 
                             c("Lower","Upper","Extremes","Center"), NA),
                 numericInput("q1_df", "t degrees of freedom?", 10 )
               )),   
               ##  dist'n shows 'normal' by default, but conditional box for t df appears.
               column(8,
                      plotOutput('tProbPlot1')
               )  #,
               #  h6("t distribution")
      ),
      tabPanel("Power", value = "Power",
               ## ui.r from power app
               #  Application title
               titlePanel("Power Demo"),
               # Sidebar with sliders that demonstrate various available options
               fluidRow(
                 column(4, inputPanel(
                   sliderInput("pwr_n", "SampleSize:", 
                               min=4, max=50, value=10),
                   # std deviation
                   sliderInput("pwr_sd", "Standard Deviation:", 
                               min = 0.4, max = 3.2, value = 1.0, step= 0.2),
                   # 
                   sliderInput("pwr_altMean", "Alternative Mean:",
                               min = 0, max = 8, value = 2, step=.1),
                   # alpha level
                   sliderInput("pwr_alpha", "Significance Level:", 
                               min = 0.01, max = .15, value = .04, step= 0.01)    
                 )),
                 column(8, plotOutput("powerPlot"))),
               # Show a table summarizing the values entered
               fluidRow(column(8, offset = 4, tableOutput("powerValues")))
      )
    )
}    ,

    ####   Two Categorical  -------------------------------------------------  --  2 cat
{
  navbarMenu("Two Categ.",
      tabPanel("Enter /Describe Data", value="2catDataEntry",
               h5(textOutput('cat2DataIn')),
               br(),
               fluidRow( 
                 column(5,   ##  Inputs
                        fluidRow( 
                          column(4,
                               div( pre(""),
                                   tags$input(name='cat2_name1', type='text', value='Success', size='10'),
                                   br(),
                                   tags$input(name='cat2_name2', type='text', value='Failure', size='10')
                               )
                           ),
                          column(4,
                                 div( 
                                   tags$input(name='cat2_grp1', type='text', value='Group1', size='10', height = 20),
                                   br(), 
                                   tags$input(name='cat2_n11', type='text', value='0', size='10'),
                                   br(),
                                   tags$input(name='cat2_n21', type='text', value='0', size='10')
                                 )
                          ),
                          column(4,
                                 div(  
                                   tags$input(name='cat2_grp2', type='text', value='Group2', size='10', height = 20),
                                   br(),
                                   tags$input(name='cat2_n12', type='text', value='0', size='10'),
                                   br(),
                                   tags$input(name='cat2_n22', type='text', value='0', size='10')
                                 )
                          )
                        ),
                    fluidRow(
                      column(6, offset = 3,
                             actionButton("cat2_submitButton", "Use These Data", height = 15)
                      )
                    )    
                 ),
                 column(4,  plotOutput('cat2Plot', width="90%")),         
                 column(3, tableOutput("cat2Summary"))       
                 )
      ),
      

      tabPanel("Test", value="2catTest",
               uiOutput('cat2_testUI')),

      tabPanel("Estimate", value="2catEstimate",
               uiOutput('cat2_estimateUI')
      ),
               
      tabPanel("Normal Distribution", value="2catNormal",
               titlePanel("Normal Probabilities"),
               column(4, inputPanel(
                 #helpText("Either enter  "),
                 textInput('cat2_z_txt', label='Standardized Value: ', value=" "),
                 #helpText("Or "),
                 textInput('cat2_prob_txt', 'or  Probability: ', " "),
                 selectInput("cat2_area", "To go into which area? ", 
                             c("Lower","Upper","Extremes","Center"), NA)#,
                 #selectInput("cat2_dist", "Distribution: ",c("Normal"), "Normal"),
                 #conditionalPanel( 
                #   condition = "input.prb_dist =='t'", 
                #   numericInput("cat2_df", "t degrees of freedom?", 10 ))
               )),   
               column(8,
                      plotOutput('normalProbPlot2')
               )  #,
            ##  h6("Normal Approx")
      )
    )
} ,
    ####   Two Quantitative ------------------------------------------------- -- 2 Quant 
{
 navbarMenu("Two Quant.",
               tabPanel("Enter /Describe Data", value="2quantDataEntry",
               ##  preloaded data  - save as data/quant1.RData
               ##  read local csv file
               ##  open empty table to copy or type in data.
               ##
               ##  Existing data is stored in "data/quant2.RData"
               h4(textOutput('quant2DataIn')),
               fluidRow(  
                 
                 column(6, selectInput('q2_entry', '', 
                                       list(" ", "Pre-Loaded Data","Local CSV File","Type/Paste into Data Table"), 
                                       selected = " ",
                                       selectize = FALSE))
               ),
                            
               uiOutput("q2_ui"),
               
               hr(),
               fluidRow(
                 column(6, 
                        plotOutput('q2_Plot') ),
                 column(5, 
                        tableOutput('q2_Summary'))
               ),
               fluidRow( 
                 column(4, uiOutput("q2_swap"))
               )
               ),      
      tabPanel("Test", value="2quantTest",
               uiOutput('q2_testUI')
      ),
      
      tabPanel("Estimate Slope/Correlation", value="2quantEstimate",
               uiOutput('q2_estimateUI')
      )
    )
},
  ####   1 categorical & 1 quantitative  -----------------------------------
{
  navbarMenu("One of Each",
               
      tabPanel("Enter /Describe Data", value="1cat1quantDataEntry",
       h4(textOutput('c1q1DataIn')),
        fluidRow(  
            column(6, selectInput('c1q1_entry', ' ', 
                                list(" ", "Pre-Loaded Data","Local CSV File","Type/Paste into Data Table"), 
                                selected = " ",
                                selectize = FALSE))
        ),
        
        uiOutput("c1q1_ui")
        ,
        hr(),
        fluidRow(
          column(5, 
                 plotOutput('c1q1_Plot') ),
          column(4, 
                 tableOutput('c1q1_Summary1'),
                 br(),
                 tableOutput('c1q1_Summary2'))
        )
        
      ),
      
      tabPanel("Test", value="1cat1quantTest",
               uiOutput('c1q1_testUI')
      ),
      
      tabPanel("Estimate", value="1cat1quantEstimate",
               uiOutput('c1q1_estimateUI')
      ),
      
      
      tabPanel("t Distribution", value="1cat1quantT",
               titlePanel("t Probabilities"),
               column(4, inputPanel(
                 #helpText("Either enter  "),
                 textInput('c1q1_z_txt', label='Standardized Value: ', value=" "),
                 #helpText("Or "),
                 textInput('c1q1_prob_txt', 'or  Probability: ', " "),
                 selectInput("c1q1_area", "To go into which area? ", 
                             c("Lower","Upper","Extremes","Center"), NA),
                 #selectInput("c1q1_dist", "Distribution: ",c("t"), "t"),
                 numericInput("c1q1_df", "t degrees of freedom?", 10 )
               )),   
               ##  dist'n shows 'normal' by default, but conditional box for t df appears.
               column(8,
                      plotOutput('tProbPlot2')
                )  
      )
    )
}
      
)
)

