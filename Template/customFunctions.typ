#import "@preview/gloss-awe:0.0.5": *
#import "../abbreviations.typ": *
#import "../glossary.typ": *
#import "@preview/treet:0.1.0": *


#let attributedQuote(label, body) = [
  #pad(left: 1em, right: 1em, rest: 3em)[
      // use a box to prevent the quote from beeing split on two pages
      #box(
        quote(
          block: true, quotes: true, attribution:             [#cite(label.target, form: "author") #label])[
        #body
    ])
  ]
  ]
  


#let codeFigure(caption, plabel, filename) = [
  #figure(
    caption: caption,
    kind: "code",
    supplement: [Code],
    include "../Code/" + filename + ".typ"
  ) #plabel
]

#let imageFigure(plabel, filename, pCaption, height: auto, width: auto) = [
  #figure(
    image("../Images/" + filename, height: height, width: width),
    caption: pCaption,
  ) #plabel
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