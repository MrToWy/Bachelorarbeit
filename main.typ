#import "Template/template.typ": *

#show: project.with(
  title: "Konzeption und Entwicklung eines Systems zur Verwaltung und Erstellung von Modulhandbüchern",
  subtitle: "Bachelorarbeit im Studiengang Mediendesigninformatik",
  author: "Tobias Wylega",
  author_email: "tobias@wylega.de",
  matrikelnummer: 1629483,
  prof: [
    Prof. Dr. Dennis Allerkamp\
    Abteilung Informatik, Fakultät IV\
    Hochschule Hannover\    
    #link("mailto:dennis.allerkamp@hs-hannover.de")
    
  ],
  second_prof: [
    Prof. Dr. Matthias Hovestadt\
    Abteilung Informatik, Fakultät IV\
    Hochschule Hannover\    
    #link("mailto:matthias.hovestadt@hs-hannover.de")
  ],
  date: "15. August 2024",
  glossaryColumns: 1
)
 
#include "Chapters/1-Einleitung.typ" 
#include "Chapters/2-Planung.typ" 
#include "Chapters/3-Entwurf.typ" 
#include "Chapters/4-Implementierung.typ" 
#include "Chapters/5-Review.typ" 