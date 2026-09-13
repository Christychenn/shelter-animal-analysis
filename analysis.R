library(jsonlite); library(purrr); library(stringr); library(ggplot2)
dir.create("data", showWarnings = FALSE)
dir.create("plots", showWarnings = FALSE)


animalShelterData <- 
  jsonlite::fromJSON("https://www.dropbox.com/s/jew0opl6emhnw8o/animal_shelter.json?dl=1")
animalShelterData
new_animal_data <-list()
# animalShelterData is an observation-by-obs data with each observation representing a page.
# We can change it to fbf data through
purrr::transpose(animalShelterData) -> animalShelterData_fbf

unlist(animalShelterData_fbf$description, recursive=F) ->
  descriptions
unlist(animalShelterData_fbf$photo, recursive = F) -> 
  photos

animalShelterData2 <- vector("list", length(descriptions))
for(.x in seq_along(animalShelterData2)){
  descriptions[[.x]] |> 
    stringr::str_extract(".*(?=：)") |>
    stringr::str_remove_all("\\s") -> .colnames
  descriptions[[.x]] |>
    stringr::str_extract("(?<=：).*") |>
    stringr::str_remove_all("\\s") -> .values
  names(.values) = .colnames
  list_values = as.list(.values)
  
  list_values$照片=photos[[.x]]
  
  list_values -> animalShelterData2[[.x]]
}

purrr::transpose(animalShelterData2) -> animalShelterData3_fbf
list2DF(animalShelterData3_fbf) -> df_animalShelter

View(df_animalShelter)
#顏色統計
df_animalShelter$毛色 |> unlist() |> factor() -> color
color |> table() 
data.frame(table(color))->df_color 
ggplot(data = df_color,aes(x = color, y = Freq))+
  geom_bar(stat = "identity")+
  theme(text = element_text(family = "Heiti TC Light"))-> bar_color
bar_color+ coord_flip()

#品種統計
df_animalShelter$品種 |> unlist() |> factor() ->breed
breed |> table() |> data.frame() -> df_breed
ggplot(data = df_breed ,aes(x = Freq , y= breed))+
  geom_bar(stat = "identity")+
  theme(text = element_text(family = "Heiti TC Light"))-> bar_breed
bar_breed
#體型統計
df_animalShelter$體型 |> unlist() ->bodyshape
factor(bodyshape, levels = c("迷你型","小型","中型","大型"))->fac_bodyshape
table(fac_bodyshape) |> data.frame() -> df_bodyshape
ggplot(data = df_bodyshape, aes(x= Freq, y=fac_bodyshape ))+
  geom_bar(stat = "identity")+
  theme(text = element_text(family = "Heiti TC Light")) ->bar_bodyshape
bar_bodyshape

#年齡統計
df_animalShelter$年齡 |> unlist() |> factor() -> age
str_sub(age,start = 1 , end = 1)->age #因為幼犬有分幾個月全部統整為幼犬
age |> table() |> data.frame() -> df_age
ggplot( data = df_age, aes(x = Freq , y = age))+
  geom_bar( stat = "identity") +
  theme(text = element_text(family = "Heiti TC Light")) ->bar_age
bar_age
#進所原因
df_animalShelter$進所原因 |> unlist() |> factor() -> reason
reason |> table() |> data.frame() -> df_reaon 


#空的資料？？
#拾獲地點
df_animalShelter$拾獲地點 |>unlist() -> findLocation
str_sub(findLocation,start = 1,end = 3) ->findLocation
findLocation |> factor()  |> table() |>  data.frame()-> df_findLocation
#data frame 要怎麼改欄位名稱
ggplot( data = df_findLocation , aes(x=Var1 , y=Freq))+
  geom_bar(stat = "identity")+
  theme(text = element_text(family = "Heiti TC Light")) -> bar_findLocation
bar_findLocation+coord_flip()
#加數字
#導入新北市收容所統計資料
jsonlite::fromJSON("https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=DyplMIk3U1hf&$top=2000&$skip=0&rpt_country_code=City000003")->new_taipei
jsonlite::fromJSON("https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=DyplMIk3U1hf&$top=2000&$skip=0&rpt_country_code=City000003",F)->new_taipei_obo
#每一年度的資料數量不一樣
new_taipei$rpt_year |> unlist() |> factor() |> table()
#統計各年度資料
new_taipei_eachyear <- list()
#97-101年
new_taipei_obo[113:117] ->new_taipei_eachyear[1:5]
#102-108年 推測月份為0整年為統計數


#109-110年 加總


nrow(df_animalShelter)
sort(table(breed), decreasing = TRUE) |> head(5)
sort(table(color), decreasing = TRUE) |> head(5)
table(fac_bodyshape)
table(age)
sort(table(findLocation), decreasing = TRUE) |> head(5)






