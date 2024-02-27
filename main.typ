#import "Template/template.typ": *


#show: project.with(
  title: "Modulhandbücher",
  subtitle: "Bachelorarbeit im Studiengang Mediendesigninformatik",
  author: "Tobias Wylega",
  author_email: "tobias@wylega.de",
  prof: [
    Prof. Dr. Dennis Allerkamp\
    Abteilung Informatik, Fakultät IV\
    Hochschule Hannover\    
    #link("mailto:dennis.allerkamp@hs-hannover.de")
    
  ],
  second_prof: [
    Prof. Dr. Dennis Allerkamp\
    Abteilung Informatik, Fakultät IV\
    Hochschule Hannover\    
    #link("mailto:dennis.allerkamp@hs-hannover.de")
  ],
  date: "15. August 2024",
)


#let codeFigure(caption, plabel, filename) = [
  #figure(
  caption: caption,
  kind: "code",
  supplement: [Code],
  include "Code/" + filename + ".typ"
  ) #plabel
]

#codeFigure("Test", <HelloWorld>, "HelloWorld")

In @HelloWorld you can see...




= Introduction
What is ```rust fn main()``` in Rust
would be ```c int main()``` in C.




== Zitieren
In Harry Potter @harry finden sich viele tolle Geschichten. @electronic

== 1
#lorem(500)
== 2
#lorem(1500)

#pagebreak()

== 3
#lorem(500)

=== Contributions
#lorem(40)

= Related Work
#lorem(500)



