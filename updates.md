## March 21

Today we initiated our projects. I am still deciding between a Mariokart Character Builder Shiny app and a Shiny app showing the impact of spin-rates on MLB Pitches. I spent time scraping the Mariokart wiki to get the statistics for each Kart, Wheel, and Character. I still need to scrape to gather the data for the Gliders, as well as the "Hidden Statistics." These are the statistics which aren't visible while in the game, but are in the game's code.

## March 23 

### Beginning of Class

Got all of the data in and began to create an idea for a shiny app, as well as trying to combine the data sets. 

### End of Class

Today I got a working graph and a plan on how to make the graph work in the Shiny app. I finally figured out the strategy of turning the row names to acolumn in order to make the bar chart functionable. From this, I tried to get it into my shiny app but ran into trouble with the reactive settings when turning these row names into a column. I hope to overcome this problem and be able to run my shiny app without receiving error messages.
Edited my data to begin to make the static table, which I want showing up as a reactive table in my shiny app. I also brainstormed other ideas to include in my final project, such as graphs to show and presenting the tracks which the chosen combination is optimized for. My goal is to be able to show some sort of reactive table by in time for class on Monday, 3/28.

## March 29

This push is coming a day late as I was sick for class on the 28th. I have worked on my project to get the reactive table to display. I am still working and attempting to better format this table as well as try to add a reactive graph into my app. At the moment the table works exactly how I want it to apart from the fact it does not display the column names for each variable. 


## March 30

### Beginning of class

I have  began to add the bar plot I plan to have demonstrating the values in the table. A bar plot is what shows up in the in-game character selector, but it is small and you can not really analyze it other than comparing sizes of bars. I have an idea of how I want this graph to be in, using the dataset _before_ I sum the columns, but currently I have still not gotten it to work.

### End of class

Today in class I accomplished a few different tasks. First was I was able to get labels on my table and have it formatted as I initially desired. Secondly, I was able to create two separate tabs for my Shiny app which is how I eventually want my final to look. I also began initializing a graph, which I still am trouble shooting. I also read in a new data set, which shows the world records for each course and kart combinations. Hopefully I can have that data set incorporated into my Shiny app by next class. It will require me to tidy up a lot of the entries though, which I did accomplish some of in class.

## April 4

## Beginning of Class

My updates from this weekend of work include fully reading in and tidying the World Record data. I also added another tab which included the World Record data table. I also added the data into my geom_bar(), but it still is unresponsive. I know that I have a poor approach at the graph right now, however my priority is to first fix all of my tables. Adding the World Record table lead to problems in my other two tabs, which I have spent the last majority of my time trying to fix.

## End of Class

I had a very productive day in class. I found a new dataset with the same information, but requires less tidying and has better column names. This also allowed me to fix a few bugs with one of my tables. I am still stumped on how to get the summarized columns into a graph, but my goal for class on Wednesday is to have a fully functional Shiny app with a graph output in the second tab.


## April 6

## Beginning of Class

My updates for the beginning of class commit include editing and combining my new data frames, reading the data for the world records, and trying to find a way to combine them. Most of this work came outside of my Shiny app, trouble shooting instead of adding new features to my app. 
