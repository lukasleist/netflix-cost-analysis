install.packages("xlsx")
install.packages("anytime")

library("xlsx")
library("ggplot2")
library("anytime")

# Daten Importieren
data = read.xlsx("./analyse.xlsx", sheetName = "Export")
data$Time = anytime(data$Time)
data$Cost.per.Customer.per.Month = data$Cost.per.Customer..excluding.marketing. / 3

data$Cost.per.Movie = 0
data$Cost.per.Movie[data$Segment == "DVD"] = data[data$Segment == "DVD", "Cost.per.Customer.per.Month"] / 8
data$Cost.per.Movie[data$Segment == "Streaming"] = data[data$Segment == "Streaming", "Cost.per.Customer.per.Month"] / 30


# Plot von Anzahl Kunden zu Kosten pro Kunde DVD/Streaming (Domestic)
ggplot(
  data,
  aes(
    y = Cost.per.Customer.per.Month,
    x = Total.subscriptions.at.end.of.period,
    group = Segment,
    color = Segment
  )
) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(y = "Kosten pro Nutzer [USD/Monat]",
       x = "Nutzer [Tsd.]")

# Plot von Anzahl Kunden zu Kosten pro Film DVD/Streaming (Domestic)
ggplot(
  data,
  aes(
    y = Cost.per.Movie,
    x = Total.subscriptions.at.end.of.period,
    group = Segment,
    color = Segment
  )
) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(y = "Kosten pro Film [USD]", x = "Nutzer [Tsd.]")


# Anzahl der Nutzer von Netflix (Domestic)
ggplot(data) +
  geom_line(aes(x = Time, y = Total.subscriptions.at.end.of.period, color = Segment), size = 1.5) +
  labs(x = "Jahr", y = "Abonnements")
