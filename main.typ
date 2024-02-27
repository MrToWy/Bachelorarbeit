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







#import "@preview/hydra:0.3.0": hydra, anchor
= Introduction

What is ```rust fn main()``` in Rust
would be ```c int main()``` in C.

#codeFigure("Test", <HelloWorld>, "HelloWorld")

In @HelloWorld you can see...



== Zitieren
In Harry Potter @harry finden sich viele tolle Geschichten. @electronic

== Motivation
#lorem(500)
== Lorem Ipsum
#lorem(1500)

#pagebreak()

= Brem En
#lorem(500)

=== Contributions
#lorem(40)

= Related Work
#lorem(500)



