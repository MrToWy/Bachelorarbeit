#import "@preview/gloss-awe:0.0.5": *
#import "../abbreviations.typ": *
#import "../glossary.typ": *
#import "@preview/treet:0.1.0": *
#import "@preview/big-todo:0.2.0": *

#let sidePadding = 1em
#let topBotPadding = 3em

#let smallLine = line(length: 100%, stroke: 0.045em)

#let exampleText(content: none) = {
  if(content == none){
    return
  }
[
  #linebreak()
  #text(weight: "semibold")[Beispiel: ]
  #content
]
}
  

#let track(title, padding: topBotPadding/8, type: "Info", example: none, content) = {
  let c = counter(type)
  c.step()
  [
  #context[
    #let number = str(c.get().first())
    #let name = type+number 
    #pad(top: padding, bottom: padding)[
    #text(weight: "semibold")[
    #smallcaps(name + ": " + title)
  ] #linebreak()
  #content
  #exampleText(content: example)
  ]]]
}

#let narrowTrack(title, type: "Info", content) = [
  #track(title, padding: 0em, type: type, content)
]


#let useCase(nummer, kurzbeschreibung, akteur, vorbedingungen, hauptszenario) = [
  #pad(left: 0em, right: 0em, rest: topBotPadding/2)[
  #figure(caption: [Use Case #nummer])[
  #block()[
  #show table.cell.where(x: 0): set text(weight: "bold")

    #table(
      columns: (0.4fr, 1fr),
      fill: (x, y) => if calc.even(x) { rgb("E28862") } else { rgb("EEC0AB") },
      stroke: (x: none, y: 2.5pt + rgb("FFFF")),
  

      [Name], [UC] + str(nummer),
      [Kurzbeschreibung], kurzbeschreibung,
      [Akteur], akteur,
      [Vorbedingungen], vorbedingungen,
      [Hauptszenario], hauptszenario
    )
  ]]]
]


#show figure: set block(breakable: true)
#let anforderung(funktional: true) = [
  #let prefix = if(funktional) {"F"} else {"N"}
  
  #figure(caption: if funktional {"Funktionale Anforderungen"} else {"Nicht-Funktionale Anforderungen"})[

  #show table.cell.where(x: 0): set text(weight: "bold")
    #let results = if(funktional) {csv("../anforderungen.csv")} else {csv("../nichtFuntionaleAnforderugen.csv")} 
    #let counter = 1
    
    #table(
      columns: (1fr, 9fr),
      fill: (x, y) => if calc.even(x) { rgb("E28862") } else { rgb("EEC0AB") },
      stroke: (x: none, y: 2.5pt + rgb("FFFF")),
      [*Name*], [*Beschreibung*],
      
      ..results.enumerate(start: 1).map(((i, row)) => ([#prefix#(i)#label(row.first())], 
      row.last()
      
      )).flatten(),
    )
  ]
]

#let getAnfName(label, prefix)=[
  #context(
  link(label, text(prefix) + query(
    selector(label),
  ).first())
  )
]


#let attributedQuote(label, body) = [
  #pad(left: sidePadding, right: sidePadding, rest: topBotPadding)[
      // use a box to prevent the quote from beeing split on two pages
      #box(
        quote(
          block: true, quotes: true, attribution:             [#cite(label.target, form: "author") #label])[
        #body
    ])
  ]
  ]
  


#let codeFigure(caption, plabel, filename) = [
  #pad(left: sidePadding, right: sidePadding, rest: topBotPadding)[
  #figure(
    caption: caption,
    kind: "code",
    supplement: [Code],
    include "../Code/" + filename + ".typ"
  ) #plabel
]]

#let imageFigure(plabel, filename, pCaption, height: auto, width: auto) = [
  #align(center)[
  #pad(left: sidePadding, right: sidePadding, rest: topBotPadding)[
  #figure(
    image("../Images/" + filename, height: height, width: width),
    caption: pCaption
  ) #plabel
]]]

#let treeFigure(pLabel, pCaption, content) = [
#pad(left: sidePadding, right: sidePadding, rest: topBotPadding)[
#par(leading: 0.5em)[
#figure(caption: pCaption)[
#align(left)[
#tree-list(content)]] #pLabel ]]
]



// header
#import "@preview/hydra:0.3.0": hydra

#let getCurrentHeadingHydra(loc, topLevel: false, topMargin) = {
    if(topLevel){
      return hydra(1, top-margin:topMargin)
    }
    
    return hydra(top-margin:topMargin)
}

#let getCurrentHeading(loc, topLevel: false, topMargin) = {

    let chapterNumber = counter(heading).display()
    if(topLevel){
      chapterNumber = str(counter(heading).get().at(0))
    }
  
    let topLevelElems = query(
      selector(heading).before(loc),
      loc,
    )

    if(topLevel){
      topLevelElems = query(
      selector(heading.where(level: 1)).before(loc),
      loc,
      )
    }
    
    let currentTopLevelElem = ""
    
    if topLevelElems != () {
      currentTopLevelElem = topLevelElems.last().body
    }
    
    return chapterNumber + " " + currentTopLevelElem
}