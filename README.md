# R6 Classes to UML

> [!IMPORTANT]
> This repository has been copied from https://gitlab.com/b-rowlingson/R6toPlant
> so that I can generate a tag and create a conda package that will be available at
> https://anaconda.org/channels/tidywf.

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

On systems with a `plantuml` command (_e.g._, Ubuntu has an eponymous package) one can also do

```
plantuml -tpng out.uml
```

to create a file `out.png`.
See `plantuml -h` (or `java -jar /opt/plantUML/plantuml.jar -h`) for more options.

