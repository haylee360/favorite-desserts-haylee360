library(tidyverse)
library(here)
library(janitor)
library(rvest)  # used to scrape website content

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of element of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as a proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv

# read in our favorite desserts csv
my_desserts <- read_csv(here("favorite_desserts.csv")) %>% clean_names()

my_desserts_vec <- my_desserts$favorite_dessert
their_desserts_vec <- dessert_listing$dessert

# This if else loop was dumb and didn't work
# if (my_desserts_vec %in% their_desserts_vec) {
#   print(paste("Yes!"))
# } else print("No :/") 
# 
# for (i in seq_along(dessert_listing$dessert)){
#   if (my_desserts$favorite_dessert == (i)) { 
#     print(paste("It's a match at", (i))
#   if(!flag)
#     print("Element is not present in the vector")        

# Match works but doesn't show you what the desert is. Just gives row output. But it's quick and easy
match(my_desserts$favorite_dessert, dessert_listing$dessert)

#Changing a dessert to test for match
my_desserts <- my_desserts %>% 
  mutate(favorite_dessert = str_replace(string = my_desserts$favorite_dessert, replacement = "Cheesecake", pattern = "caramel apple")) 

# Inner join method: definitely the best
inner_join(my_desserts, dessert_listing,join_by(favorite_dessert == dessert))
