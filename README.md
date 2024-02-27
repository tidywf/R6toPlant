# R6 Classes to UML

## Example

```
library(R6)
example(R6)
pkgload::load_all("./R6toPlant")
make_plant(list(Queue, CountingQueue, HistoryQueue, Cloner, CustomCloner), "out.uml")
```

Then assuming your PlantUML is setup in `/opt/plantUML` like mine and you've not
got a shell script set up for it and yeah I just copy-pasted this from another project
of mine:

```
cat out.uml | java -jar /opt/plantUML/plantuml.jar -charset UTF-8 -tsvg -pipe > out.svg
```

