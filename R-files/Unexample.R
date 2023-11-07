un_data = read.csv("country_profile_variables.csv")
logGDP = log(un_data$GDP.per.capita..current.US..)
Fert = as.numeric(un_data$Fertility.rate..total..live.births.per.woman.)
Fertcomp = complete.cases(Fert) & (Fert >= 0)
GDPcomp = complete.cases(logGDP) & (logGDP >= 0)

Total_comp = Fertcomp & GDPcomp

logFertility = log(Fert[Total_comp])
logGDPpp = logGDP[Total_comp]
Purban = un_data$Urban.population....of.total.population.
Purban = Purban[Total_comp]
LM1 = lm(logGDPpp ~ Purban)
df1 = data.frame(logGDPpp, logFertility, Purban)
plot(df1)
summary(LM1)
LM2 = lm(logFertility ~ Purban)
summary(LM2)