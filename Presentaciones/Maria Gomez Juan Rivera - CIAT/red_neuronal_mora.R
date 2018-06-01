

#Ejercicios practico
#Big Data Workshop CO
#------------------CIAT------------------------------
#Grupo de Big Data y agricultura especifica por sitio
#----------------------------------------------------


#Este es un ejemplo de redes neuronales utilizando un
#conjuntos de datos de mora.


#Redes Neuronales en R


rm(list=ls())

#Instalar paquetes
install.packages("caret")
install.packages("nnet")


#Load 
library(caret)
library(nnet)


#Leer los datos
datos_mora <- read.csv("mora_toyset.csv",row.names = 1)

colnames(datos_mora) <- c("Mora_con_Espinas", "Mora_sin_Espinas", 
"Narino", "Caldas", "Caldas_Riosucio", "Narino_Cusillo_Al",
"Narino_Cusillo_Bj", "Altitud", "Pendiente", "Drenaje_Interno", 
"Drenaje_Externo", "Profundidad", "Agua_mes0_cosecha", "Agua_mes1_cosecha",
"Agua_mes2_cosecha", "Agua_mes3_cosecha", "Temperatura_Promed_mes0", 
"Rango_temp_mes0", "Prec_acum_mes0", "Temperatura_Promed_mes1", 
"Rango_temp_mes1", "Prec_acum_mes1", "Temperatura_Promed_mes2", 
"Rango_temp_mes2", "Prec_acum_mes2", "Temperatura_Promed_mes3",
"Rango_temp_mes3", "Prec_acum_mes3", "Rendimiento") 



#Particion
set.seed(123)
inTrain  <- createDataPartition(y=datos_mora$Rendimiento, p=0.7, list=F)
training <- datos_mora[inTrain,]
testing  <- datos_mora[-inTrain,]


#Normalizacion
norm_training <- preProcess(training,method = "range")
training_norm <- predict(norm_training,training)
testing_norm  <- predict(norm_training,testing)


#Optimizacion de parametros
ctrl <- expand.grid(size = c(2,4,6) ,decay = c(0.1,0.5,0.8) )


#Entrenamiento
model <- train(Rendimiento~.,data=training_norm,method = "nnet",
               tuneGrid = ctrl, trControl = trainControl(method = "cv",number = 10),
               lineout =T)



#Desempeño del modelo
pred_val <- predict(model,testing_norm)
postResample(pred_val,testing_norm$Rendimiento)
plot(pred_val,testing_norm$Rendimiento,col="red",pch=19)
abline(0,1,lty=2)




#Relevancia de variables
varImp <- varImp(model)
plot(varImp)



