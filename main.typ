#let template(doc) = [
    #set heading(numbering: "1.")
    #doc
]
#show: template


#let title = [
  Bachelorarbeit
]

#let amazed(term, color: blue) = text(color, box[✨ #term ✨])





#align(center, text(17pt)[
  *#title*
])

#grid(
  columns: (1fr, 1fr),
  align(center)[
    Therese Tungsten \
    Artos Institute \
    #link("mailto:tung@artos.edu")
  ],
  align(center)[
    Dr. John Doe \
    Artos Institute \
    #link("mailto:doe@artos.edu")
  ]
)

= Introduction
You are #amazed[beautiful]!
You are #amazed(color: purple)[purple]!

What is ```rust fn main()``` in Rust
would be ```c int main()``` in C.

```rust
fn main() {
    println!("Hello World!");
}
```

New Line!

== Subheading
#lorem(10)

=== Sub-subheading
#lorem(25)

+ Bullet point
    - Sub-bullet point
+ Bullet point

#image("Logo.svg", width: 10%)

Die @wortmarke kann auch als Bild eingefügt werden.

#figure(
  image("Wortmarke.svg", width: 10%),
  caption: [
    _Fakultät 4_ Wortmarke.
  ],
  kind: "Abbildung",
  supplement: [Abbildung],
) <wortmarke>


= Zitieren
In Harry Potter @harry finden sich viele tolle Geschichten. @electronic

#bibliography("sources.yaml", style: "springer-lecture-notes-in-computer-science")
