# --------------- A UTILISER -------------------- #

library(disk.frame)
library(parallel)

nCores <- detectCores()    # Dépend de la machine
setup_disk.frame(workers = nCores)
options(future.globals.maxSize = Inf)

# Chargement du CSV + Génération des fichiers
df1 <- csv_to_disk.frame(
  file.path("data/", "train.csv"), 
  outdir = file.path("data/", "train.df"),
  inmapfn = base::I,
  recommend_nchunks(sum(file.size(file.path("data/" , "train.csv")))),
  backend = "data.table")


train <- collect(sample_frac(df1, 0.05)) # Split avec un sample de 60% de df

train <- select(train, type, amount, nameOrig , nameDest, isFraud, isFlaggedFraud)

train$type = as.numeric(as.factor(train$type))
train$nameOrig = as.numeric(as.factor(train$nameOrig))
train$nameDest = as.numeric(as.factor(train$nameDest))

# ---------------- WIP ---------------- #

# df2 <- collect(sample_frac(df1, 1)) # df en entier
# diff <- setdiff(df2, train) # Différence entre le df en entier (df2) et train pour récupérer les 40% restants
# test <- collect(sample_frac(diff, 0.50)) # 20% (50% de la diff)
# validation <- setdiff(diff, test) # 20%, diff des 50%

# df2 <- select(df2, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig, oldbalanceDest, newbalanceDest, isFraud, isFlaggedFraud) # Uniquement les variables intéressantes (WIP)
# train <- select(train, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig, oldbalanceDest, newbalanceDest, isFraud, isFlaggedFraud)# ""



test <- select(test, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig, oldbalanceDest, newbalanceDest, isFraud, isFlaggedFraud)# ""

df2$isFraud <- factor(df2$isFraud) # Changement du type de variable pour isFraud
train$isFraud <- factor(train$isFraud)
test$isFraud <- factor(test$isFraud)
diff$isFraud <- as.numeric(diff$isFraud)



train$nameOrig <- as.factor(train$nameOrig)
df2$type <- as.factor(df2$type) # Passage de la donnée qualitative en quantitative (1, 2, 3)
train$type <- as.factor(train$type)
test$type <- as.factor(test$type)


