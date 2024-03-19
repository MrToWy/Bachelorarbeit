#import "@preview/gloss-awe:0.0.5": *
#import "../abbreviations.typ": *
#import "../glossary.typ": *
#import "@preview/treet:0.1.0": *
#import "@preview/big-todo:0.2.0": *

#let sidePadding = 1em
#let topBotPadding = 3em

#let smallLine = line(length: 100%, stroke: 0.045em)

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
#tree-list()[
- StudyBase/src
  - Plan
    - Plan.Module
    - Degrees
      - Degree.Module
      - Degree.Controller
      - Degree.Service
  - Shared
    - Mailer
      - Mailer.Module
      - Mailer.Service
    - Prisma
      - Prisma.Module
      - Prisma.Service    
]]] #pLabel ]]
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