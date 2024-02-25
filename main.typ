#let title = [
  Bachelorarbeit
]

#set text(
  font: "New Computer Modern",
  size: 11pt
)
#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 1.5cm),
  header: align(right, title),
  numbering: "1",
)
#set par(
  justify: true,
  leading: 0.52em,
)

#set heading(numbering: "1.")

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
