#let codeFigure(caption, plabel, filename) = [
  #figure(
  caption: caption,
  kind: "code",
  supplement: [Code],
  include "../Code/" + filename + ".typ"
  ) #plabel
]

#import "@preview/hydra:0.3.0": hydra

#let getCurrentHeadingHydra(loc, topLevel: false) = {
    if(topLevel){
      return hydra(1)
    }
    
    return hydra()
}

#let getCurrentHeading(loc, topLevel: false) = {
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
    
    return currentTopLevelElem
}