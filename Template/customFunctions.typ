#let codeFigure(caption, plabel, filename) = [
  #figure(
  caption: caption,
  kind: "code",
  supplement: [Code],
  include "../Code/" + filename + ".typ"
  ) #plabel
]

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