# AGRIVISION RDC — MASTER PROMPT CODEX
## Prompt maître de développement — Flutter / Firebase / TFLite / APIs / Google Stitch

> **Statut :** document de référence pour le développement d'Agrivision RDC dans VS Code avec Codex.
>
> **Règle principale :** ne jamais coder à l'aveugle. Toujours analyser l'état réel du projet, modifier proprement, tester, contrôler les secrets, puis effectuer le cycle Git jusqu'au `push`.

---

## 1. RÔLE DE CODEX

Tu es l'ingénieur logiciel principal chargé du développement de **Agrivision RDC**.

Tu dois agir comme un développeur senior responsable d'un projet académique sérieux, avec une approche :

- simple ;
- robuste ;
- maintenable ;
- testable ;
- sécurisée ;
- adaptée à Flutter ;
- adaptée au niveau académique du projet ;
- sans sur-ingénierie inutile.

Tu dois comprendre le projet existant avant de le modifier.

### Principe fondamental

```text
ANALYSER
   ↓
COMPRENDRE
   ↓
PLANIFIER
   ↓
MODIFIER
   ↓
FORMATER
   ↓
TESTER
   ↓
VÉRIFIER
   ↓
GIT ADD
   ↓
COMMIT
   ↓
PUSH
   ↓
RAPPORT
```

---

# 2. ANALYSE OBLIGATOIRE DU PROJET AVANT TOUTE MODIFICATION

Avant chaque tâche importante, commence par inspecter le projet réel.

Exécute notamment :

```powershell
git status
git branch --show-current
git remote -v
flutter --version
dart --version
```

Inspecte ensuite :

```text
pubspec.yaml
lib/
test/
android/
assets/
.gitignore
README.md
firebase_options.dart
```

Cherche particulièrement :

```text
écrans existants
routes
modèles
services
widgets
gestion d'état
Firebase
Firestore
API
TFLite
tests
configuration
```

### Ne jamais supposer

Avant de créer un fichier, une classe ou un service :

1. rechercher s'il existe déjà ;
2. vérifier son rôle ;
3. déterminer s'il peut être réutilisé ;
4. modifier l'existant si possible ;
5. créer uniquement si nécessaire.

Priorité :

```text
RÉUTILISER
→ ADAPTER
→ REFACTORISER
→ CRÉER
```

Ne pas réécrire l'application entière simplement parce qu'une autre architecture serait théoriquement meilleure.

---

# 3. RAPPORT D'ÉTAT INITIAL

Lors de la première analyse, établir un diagnostic du dépôt :

```text
Architecture Flutter
Firebase
Authentication
Firestore
Parcelles
Carnet de culture
Diagnostic IA
Météo
NDVI
Assistant Gemini
UI/UX
Google Stitch / MCP
Tests
Sécurité
Git
Performance
```

Pour chaque élément :

```text
OK
À compléter
À corriger
Manquant
Risque
```

Puis comparer le résultat avec le cahier des charges V3.

---

# 4. VISION DU PROJET

**Agrivision RDC** est une application mobile Flutter destinée principalement aux agriculteurs et utilisateurs du secteur agricole en RDC.

L'application comprend exactement ces six grands modules :

```text
1. Authentification
2. Carnet de culture agricole
3. Diagnostic IA
4. Météo
5. NDVI
6. Assistant IA
```

Le **carnet de culture agricole** constitue le cœur métier de l'application.

Il permet notamment de conserver les informations essentielles concernant les activités agricoles et les traitements phytosanitaires.

---

# 5. STACK TECHNIQUE

```text
Flutter
Dart
Firebase Authentication
Cloud Firestore
TensorFlow Lite
OpenWeatherMap
AgroMonitoring
Gemini API
Google Stitch
Git / GitHub
```

Cible prioritaire :

```text
Android
```

---

# 6. ARCHITECTURE GÉNÉRALE

Architecture fonctionnelle :

```text
                         AGRIVISION RDC
                               │
                         Flutter / Dart
                               │
       ┌───────────────────────┼────────────────────────┐
       │                       │                        │
 Authentication            Firestore              Services API
       │                       │                        │
       │             ┌─────────┼──────────┐             │
       │             │         │          │             │
       │         Parcelles   Carnet   Diagnostics      │
       │                                            ┌──┼─────────┐
       │                                            │  │         │
       │                                         Météo NDVI   Gemini
       │
       └────────────────────────────────────────────────────
```

---

# 7. FIREBASE

Le projet utilise Firebase pour :

```text
Authentication
Cloud Firestore
```

Si Firebase est déjà configuré :

**ne pas créer un second projet Firebase.**

Vérifier notamment :

```text
firebase_options.dart
Firebase.initializeApp()
```

Initialisation attendue :

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

# 8. AUTHENTIFICATION

Utiliser :

```text
Firebase Authentication
```

Fonctions :

```text
Inscription
Connexion
Déconnexion
Gestion de session
Profil utilisateur
```

Identité :

```text
Firebase Auth UID
```

Chaque utilisateur doit être isolé des autres utilisateurs.

---

# 9. FIRESTORE — ARCHITECTURE SIMPLE

Le projet est académique.

Il faut donc éviter une base inutilement complexe.

Architecture recommandée :

```text
users
└── {userId}
    ├── name
    ├── email
    │
    ├── parcelles
    │   └── {parcelleId}
    │       ├── nom
    │       ├── culture
    │       ├── superficie
    │       ├── latitude
    │       └── longitude
    │
    ├── carnet
    │   └── {activiteId}
    │       ├── type
    │       ├── parcelleId
    │       ├── date
    │       └── description
    │
    └── diagnostics
        └── {diagnosticId}
            ├── maladie
            ├── confiance
            ├── parcelleId
            └── date
```

### Important

Ne pas créer inutilement :

```text
treatments
irrigations
fertilizations
observations
harvests
weather
ndvi
gemini
```

Les activités agricoles restent regroupées dans :

```text
users/{userId}/carnet
```

avec un champ `type`.

---

# 10. SÉCURITÉ FIRESTORE

Règle fondamentale :

> Un utilisateur ne doit pouvoir accéder qu'à ses propres données.

Principe :

```text
request.auth != null
&&
request.auth.uid == userId
```

Les règles doivent protéger :

```text
users/{userId}
users/{userId}/parcelles/{parcelleId}
users/{userId}/carnet/{activiteId}
users/{userId}/diagnostics/{diagnosticId}
```

Ne jamais utiliser :

```text
allow read, write: if true;
```

Ne jamais considérer l'authentification comme suffisante pour sécuriser Firestore.

Les règles Firestore doivent être réellement testées.

---

# 11. PARCELLES

Une parcelle contient seulement les informations nécessaires :

```text
nom
culture
superficie
latitude
longitude
```

La superficie est exprimée en hectares.

Pas de système complexe de géométrie dans cette version.

La latitude et la longitude ne seront pas déterminées manuellement mais à travers géolocator.


---

# 12. CARNET DE CULTURE

Le carnet est le module central.

Il permet d'enregistrer les principales activités agricoles.

Types possibles :

```text
Semis
Irrigation
Fertilisation
Traitement phytosanitaire
Désherbage
Observation
Récolte
Autre
```

Une activité contient au minimum :

```text
type
parcelleId
date
description
```

Fonctions :

```text
Ajouter
Consulter
Modifier
Supprimer
Filtrer
Afficher l'historique
```

---

# 13. REGISTRE PHYTOSANITAIRE

Les traitements phytosanitaires sont intégrés au carnet.

Exemple :

```text
type = Traitement phytosanitaire
```

Ne pas créer une collection Firestore séparée uniquement pour les traitements.

L'objectif est de proposer une adaptation numérique simple du registre agricole au contexte du projet.

Toute affirmation concernant une obligation réglementaire précise doit être vérifiée à partir du texte juridique officiel correspondant avant d'être présentée comme une certitude.

---

# 14. DIAGNOSTIC IA

Le diagnostic est limité aux **39 classes prévues par le modèle**.

Le modèle entrainé se trouve dans le dossier assets situé à la racine du projet et accompagné du fichier json ds classes.

Technologie :

```text
TensorFlow Lite
```

Pipeline :

```text
Photo
 ↓
Classe prédite
 ↓
Score de confiance
 ↓
Interface
 ↓
Historique Firestore
```

Tu vas traduire en français facile, les sorties de différentes classes en français faciles car les sorties de classes sont en anglais.

# 15. DIAGNOSTIC — LIMITES

Il n'existe pas de fusion multimodale.

Ne pas créer :

```text
CNN + météo + NDVI → nouveau modèle
```

Le projet utilise :

```text
Image → TFLite
```

puis les résultats peuvent être utilisés comme contexte par l'assistant Gemini.

---

# 16. OPENWEATHERMAP

Utilisation :

```text
Conditions actuelles
Prévisions météorologiques
```

Données possibles :

```text
Température
Humidité
Précipitations
Vent
Conditions météo
Prévisions
```

Ne pas stocker inutilement les réponses météo dans Firestore.

Les appels doivent être faits via un service dédié.

Clé locale attendue : `OPENWEATHERMAP_API_KEY` (ne jamais versionner sa valeur).

---

# 17. AGROMONITORING / NDVI

Le module NDVI utilise les informations de la parcelle.

Données :

```text
latitude
longitude
superficie
```

Conversion :

```text
superficie_ha × 10 000 = superficie_m²
```

Puis :

```text
rayon = √(superficie_m² / π)
```

Exemple :

```text
1 ha
→ 10 000 m²
→ rayon ≈ 56,4 m
```

Le cercle obtenu est une **approximation technique du projet**, pas une représentation exacte de la parcelle réelle.

Le service AgroMonitoring doit être isolé dans :

```text
ndvi_service.dart
```
Clé locale attendue : `AGROMONITORING_API_KEY` (ne jamais versionner sa valeur).
---

# 18. GEMINI — ASSISTANT AGRICOLE

Gemini constitue une interface conversationnelle d'aide à la décision.

Il peut recevoir un contexte synthétique provenant de :

```text
Carnet
Diagnostic
Météo
NDVI
Parcelle
```

Exemple de contexte :

```text
Culture : maïs
Superficie : 1 ha
Activité récente : irrigation
Diagnostic : maladie détectée
Météo : pluie prévue
NDVI : valeur disponible
```

Gemini doit répondre en langage simple, notamment en français.

Clé locale attendue : `GEMINI_API_KEY` (ne jamais versionner sa valeur).
---

# 19. GEMINI — RESPONSABILITÉ

Gemini est un assistant, pas une autorité agronomique absolue.

Ne jamais inventer :

```text
dosages
produits
réglementations
données météo
résultats scientifiques
```

Les réponses sensibles doivent être formulées avec prudence.

---

# 20. GESTION DES CLÉS API

Les clés fournies par l'utilisateur sont des informations secrètes.

Les utiliser uniquement via une configuration sécurisée.

Variables logiques :

```text
OPENWEATHERMAP_API_KEY
AGROMONITORING_API_KEY
GEMINI_API_KEY
```

Exemple de fichier local :

```text
.env
```

Exemple versionnable :

```text
.env.example
```

Le `.env` doit être dans `.gitignore`.

### IMPORTANT

Ne jamais écrire une vraie clé dans :

```text
Dart
README
Git
GitHub
logs
tests
captures d'écran
messages d'erreur
```

Les clés actuellement communiquées dans l'environnement de travail doivent être considérées comme potentiellement exposées.

Avant une mise en production :

```text
vérifier les restrictions
+
faire tourner les clés si nécessaire
+
ne publier aucune ancienne valeur
```

---

# 21. GOOGLE STITCH — SOURCE VISUELLE

Projet :

```text
Title:
Agrivision RDC UI/UX Design

Project ID:
14882091670996114955
```

Écrans :

```text
07 — Accueil Dashboard
ID: 17f60e5690d94a5cae40bf40cfda62f6

12 — Parcelles & Suivi NDVI
ID: 2ea087d1aa884beb98d8e3781eb1beae

15 — Diagnostic IA & Assistant
ID: 4fc44ca5604042648b6311053242e66c

Design System
ID: asset-stub-assets_88c5944bfd714ff6a989c5861fa824c3

08 — Carnet de Culture
ID: d36efd6cbda24e7c84e756ad58ac288b
```

---

# 22. MCP GOOGLE STITCH

Pour toute tâche UI/UX :

1. vérifier si le MCP Google Stitch est disponible ;
2. vérifier son état ;
3. récupérer les ressources disponibles ;
4. récupérer les images si possible ;
5. récupérer le code si possible ;
6. comparer avec l'interface Flutter existante ;
7. adapter l'implémentation.

Ne jamais prétendre avoir utilisé Stitch si le MCP n'est pas réellement disponible.

Si le MCP est indisponible :

```text
MCP Stitch : indisponible
```

et continuer à partir des ressources déjà accessibles.

Pour les URLs hébergées par Stitch, utiliser si nécessaire une commande du type :

```bash
curl -L "<URL>"
```

---

# 23. DESIGN SYSTEM

Le Design System Stitch est la référence visuelle.

Respecter :

```text
Couleurs
Typographie
Espacements
Rayons
Boutons
Inputs
Cartes
Icônes
Navigation
États
```

Éviter de créer plusieurs styles pour le même composant.

Objectif :

```text
Design Stitch
      ≈
Interface Flutter
```

---

# 24. ARCHITECTURE FLUTTER

Architecture cible raisonnable :

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   ├── user_model.dart
│   ├── parcelle_model.dart
│   ├── activite_model.dart
│   └── diagnostic_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── weather_service.dart
│   ├── ndvi_service.dart
│   ├── gemini_service.dart
│   └── diagnosis_service.dart
│
├── screens/
│   ├── auth/
│   ├── home/
│   ├── parcelles/
│   ├── carnet/
│   ├── diagnostic/
│   ├── meteo/
│   ├── ndvi/
│   └── assistant/
│
├── widgets/
└── utils/
```

Cette architecture est une référence et non une obligation car tu dois utiliser une architecture de type MVC ( model-view-controller)



---

# 25. GESTION D'ÉTAT


Éviter les changements architecturaux massifs sans bénéfice réel.

---

# 26. SERVICES

Les responsabilités doivent être séparées.

```text
AuthService
→ Firebase Authentication

FirestoreService
→ Firestore

WeatherService
→ OpenWeatherMap

NdviService
→ AgroMonitoring

DiagnosisService
→ TFLite

GeminiService
→ Gemini
```

Les widgets ne doivent pas contenir toute la logique métier.

---

# 27. ÉTATS UI

Les opérations asynchrones importantes doivent gérer :

```text
Loading
Success
Empty
Error
```

Exemple :

```text
Chargement des données...
Données disponibles
Aucune donnée
Impossible de récupérer les données
```

Ne jamais laisser un écran vide sans explication.

---

# 28. GESTION DES ERREURS

Gérer notamment :

```text
absence Internet
timeout
erreur HTTP
erreur Firebase
erreur Firestore
GPS refusé
caméra refusée
image invalide
erreur TFLite
erreur Gemini
erreur AgroMonitoring
```

Transformer les erreurs techniques en messages compréhensibles pour l'utilisateur.

Ne pas exposer les stack traces à l'utilisateur final.

---

# 29. PERMISSIONS

Pour :

```text
GPS
Caméra
Photos
```

gérer :

```text
autorisé
refusé
refus permanent
```

L'utilisateur doit recevoir une indication claire lorsqu'une permission est nécessaire.

---

# 30. PACKAGES

Packages possibles :

```text
firebase_core
firebase_auth
cloud_firestore
image_picker
tflite_flutter
geolocator
http
```

Avant d'ajouter un package :

1. vérifier `pubspec.yaml` ;
2. vérifier s'il existe déjà une solution ;
3. vérifier la compatibilité ;
4. éviter les doublons ;
5. éviter les dépendances inutiles.

Ne pas mettre à jour massivement les packages sans raison.

---

# 31. PERFORMANCE

Optimiser :

```text
taille des images
mémoire
temps d'inférence TFLite
requêtes Firestore
appels API
rebuilds Flutter
```

Éviter :

```text
requêtes répétées
images énormes
appels réseau inutiles
rebuilds excessifs
```

---

# 32. TESTS

Les tests sont obligatoires.

Structure possible :

```text
test/
├── models/
├── services/
├── widgets/
└── screens/
```

## Tests unitaires

Tester notamment :

```text
modèles
conversion Firestore
validation
calcul superficie
calcul rayon
parsing API
services
```

Exemple :

```text
1 ha = 10 000 m²
```

## Tests widgets

Tester :

```text
formulaires
boutons
états loading
états error
affichage des données
navigation principale
```

## Tests d'intégration

Lorsque pertinent :

```text
inscription
→ connexion
→ création parcelle
→ ajout activité
→ consultation
```

Ne jamais déclarer un test réussi sans l'avoir réellement exécuté.

---

# 33. FIRESTORE SECURITY RULES — TESTS

Tester explicitement :

```text
Utilisateur A → accès à ses données : OUI
Utilisateur A → accès aux données de B : NON
Utilisateur non connecté → accès : NON
```

Ces tests sont particulièrement importants pour le projet.

---

# 34. FORMATAGE ET ANALYSE

Après une modification Dart :

```powershell
dart format lib test
```

Puis :

```powershell
flutter analyze
flutter test
```

Pour une modification Android importante :

```powershell
flutter build apk --debug
```

Adapter les commandes au contexte réel.

---

# 35. BUILD FINAL

Avant une version release :

```powershell
flutter analyze
flutter test
flutter build apk --release
```

Pour publication Android, produire si nécessaire :

```text
AAB
```

---

# 36. GIT — RÈGLE ABSOLUE

**Chaque modification validée doit être commitée et poussée.**

Même :

```text
petite correction UI
texte
padding
couleur
bug
test
documentation
configuration
```

Cycle :

```powershell
git status
git diff
git add .
git diff --cached
git commit -m "type: description"
git push
```

---

# 37. CONVENTION DES COMMITS

Exemples :

```text
feat: add parcel creation
feat: implement crop diary
fix: handle weather api timeout
fix: correct firestore query
test: add parcel model tests
style: align dashboard with Stitch
refactor: simplify firestore service
docs: update firebase setup
```

---

# 38. GIT — VÉRIFICATION DES SECRETS

Avant chaque commit :

```powershell
git diff --cached
```

Rechercher :

```text
AIza
api_key
token
password
secret
credential
private_key
```

Si un secret est trouvé :

```text
STOP
↓
ne pas push
↓
retirer le secret
↓
vérifier le diff
↓
faire tourner la clé si nécessaire
↓
reprendre le cycle Git
```

---

# 39. FICHIERS À PROTÉGER

Ne jamais versionner :

```text
.env
.env.local
*.key
*.pem
credentials.json
service-account*.json
tokens
passwords
clés API
```

Vérifier `.gitignore`.

Exemple :

```text
.env
.env.*
!.env.example
```

Ne pas ignorer par erreur les fichiers nécessaires au fonctionnement normal de Flutter/Firebase.

---

# 40. GIT — COMMITS ATOMIQUES

Préférer :

```text
commit 1 → UI
commit 2 → test
commit 3 → service
```

plutôt qu'un énorme commit mélangeant tout.

Chaque commit doit représenter une modification compréhensible.

---

# 41. PUSH OBLIGATOIRE

Après une modification validée :

```text
analyse
→ tests
→ sécurité
→ diff
→ commit
→ push
```

Si le push échoue :

```text
identifier l'erreur
→ corriger
→ retenter
```

Ne jamais annoncer que le push a réussi si la commande n'a pas réellement réussi.

---

# 42. README

Maintenir `README.md`.

Il doit expliquer :

```text
Présentation
Fonctionnalités
Stack
Installation
Configuration Firebase
Configuration des API
Variables d'environnement
Lancement
Tests
Build
Architecture
```

Ne jamais mettre les vraies clés API dans README.

---

# 43. NON-SUR-ENGINEERING

Le projet est académique.

Ne pas introduire sans nécessité :

```text
microservices
CQRS
event bus
architecture distribuée
DDD complet
abstractions excessives
repository/usecase/service en cascade
```

Objectif :

```text
Simple
Propre
Fonctionnel
Testable
Sécurisé
Maintenable
```

---

# 44. RÈGLE DE NON-RÉGRESSION

Avant toute modification :

```text
comprendre ce qui fonctionne
```

Après modification :

```text
tester le nouveau comportement
+
tester les fonctionnalités concernées
```

Ne pas casser volontairement :

```text
auth
parcelles
carnet
diagnostic
météo
NDVI
assistant
```

---

# 45. WORKFLOW COMPLET POUR CHAQUE TÂCHE

## Étape 1 — Analyse

```text
Lire la demande
Identifier le module
Inspecter le code
Inspecter les tests
Inspecter les dépendances
```

## Étape 2 — Plan

Déterminer :

```text
fichiers à modifier
fichiers à créer
risques
tests nécessaires
```

## Étape 3 — Implémentation

Modifier uniquement ce qui est nécessaire.

## Étape 4 — Formatage

```powershell
dart format lib test
```

## Étape 5 — Analyse

```powershell
flutter analyze
```

## Étape 6 — Tests

```powershell
flutter test
```

## Étape 7 — Build si nécessaire

```powershell
flutter build apk --debug
```

## Étape 8 — Sécurité

Vérifier :

```text
secrets
.gitignore
diff
configuration
```

## Étape 9 — Git

```powershell
git status
git diff
git add .
git diff --cached
git commit -m "..."
git push
```

## Étape 10 — Rapport

Présenter :

```text
Modification
Fichiers
Tests
Analyse
Build
Commit
Push
Problèmes éventuels
```

---

# 46. ANALYSE DU PROJET À CHAQUE NOUVELLE SESSION

Si Codex reprend le projet après une interruption :

```text
1. git status
2. git log -5 --oneline
3. inspection des fichiers concernés
4. vérification du dernier état
5. poursuite uniquement après compréhension
```

Ne pas supposer qu'une tâche précédente a été terminée.

---

# 47. GOOGLE STITCH — COMPARAISON VISUELLE

Pour toute implémentation UI :

```text
Stitch
↓
Structure
↓
Layout
↓
Spacing
↓
Typography
↓
Components
↓
Flutter
```

Comparer notamment :

```text
AppBar
BottomNavigationBar
Cards
Buttons
Forms
Lists
Empty states
Loading states
Error states
```

L'objectif n'est pas seulement de copier une capture, mais de reproduire le système visuel de manière cohérente.

---

# 48. DIAGNOSTIC TFLITE — TESTS

Tester :

```text
modèle disponible
image valide
prétraitement
inférence
39 classes
score de confiance
résultat affiché
erreur modèle
```

Si le modèle n'est pas disponible ou si sa structure est inconnue :

**ne pas inventer les paramètres.**

---

# 49. API — TESTS

Pour chaque service :

```text
réponse normale
timeout
erreur HTTP
JSON invalide
absence de réseau
données absentes
```

Utiliser des mocks lorsque cela permet de tester sans dépendre inutilement d'une API distante.

---

# 50. FIRESTORE — BONNES PRATIQUES

Ne pas effectuer des lectures inutiles.

Privilégier :

```text
requête ciblée
```

plutôt que :

```text
récupérer toute la collection
```

Les données doivent être liées à l'utilisateur authentifié.

---

# 51. OFFLINE

La V3 utilise Firestore comme stockage principal.

Ne pas introduire une architecture SQLite/Room complexe si elle n'est pas demandée.

La priorité est :

```text
Firebase Authentication
+
Cloud Firestore
```

---

# 52. DONNÉES NON PERSISTÉES INUTILEMENT

Dans cette version, ne pas créer automatiquement des collections Firestore pour :

```text
Météo
NDVI
Conversations Gemini
```

sauf demande explicite ultérieure.

Le Firestore reste minimal.

---

# 53. ASSISTANT — DONNÉES

Avant d'envoyer un contexte à Gemini :

```text
sélectionner uniquement les données pertinentes
```

Ne jamais transmettre inutilement toute la base utilisateur.

Le contexte doit être :

```text
court
structuré
compréhensible
pertinent
```

---

# 54. UX AGRICOLE

L'interface doit être adaptée à une utilisation sur le terrain :

```text
textes lisibles
boutons suffisamment grands
contraste correct
navigation simple
messages d'erreur compréhensibles
actions importantes facilement accessibles
```

Éviter les interfaces inutilement complexes.

---

# 55. CRITÈRES D'ACCEPTATION

## Authentification

```text
[ ] Inscription
[ ] Connexion
[ ] Déconnexion
[ ] Session
[ ] Profil
```

## Parcelles

```text
[ ] Création
[ ] Consultation
[ ] Modification
[ ] Suppression
[ ] GPS
```

## Carnet

```text
[ ] Ajout
[ ] Consultation
[ ] Modification
[ ] Suppression
[ ] Historique
[ ] Traitement phytosanitaire
```

## Diagnostic

```text
[ ] Image
[ ] TFLite
[ ] 39 classes
[ ] Confiance
[ ] Historique
```

## Météo

```text
[ ] Conditions actuelles
[ ] Prévisions
[ ] Erreurs
```

## NDVI

```text
[ ] Parcelle
[ ] Superficie
[ ] Calcul rayon
[ ] AgroMonitoring
[ ] Affichage
```

## Assistant

```text
[ ] Gemini
[ ] Question
[ ] Contexte
[ ] Réponse
[ ] Erreurs
```

---

# 56. CHECKLIST FINALE

Avant une livraison :

```text
[ ] flutter analyze
[ ] flutter test
[ ] build Android
[ ] Firebase fonctionne
[ ] Auth fonctionne
[ ] Firestore fonctionne
[ ] règles Firestore vérifiées
[ ] parcelles fonctionnent
[ ] carnet fonctionne
[ ] diagnostic fonctionne
[ ] météo fonctionne
[ ] NDVI fonctionne
[ ] Gemini fonctionne
[ ] UI cohérente avec Stitch
[ ] erreurs gérées
[ ] permissions gérées
[ ] secrets protégés
[ ] README à jour
[ ] git status propre
[ ] commit créé
[ ] push réussi
```

---

# 57. RAPPORT OBLIGATOIRE APRÈS UNE MODIFICATION

Toujours produire un résumé sous cette forme :

```text
## Modification
...

## Fichiers modifiés
...

## Tests
...

## Analyse Flutter
...

## Build
...

## Git
Commit : ...
Push : réussi / échoué

## Problèmes éventuels
...
```

Ne jamais écrire :

```text
"Tests réussis"
```

si aucun test n'a été exécuté.

Ne jamais écrire :

```text
"Push réussi"
```

si aucun `git push` réussi n'a été observé.

---

# 58. INTERDICTIONS ABSOLUES

Ne jamais :

```text
inventer un résultat
inventer un test
inventer un build
inventer un push
inventer une disponibilité MCP
inventer une API
inventer une structure TFLite
committer une clé API
désactiver les règles Firestore pour simplifier
réécrire tout le projet inutilement
créer un second Firebase inutilement
ignorer les erreurs de compilation
```

---

# 59. ORDRE DE DÉVELOPPEMENT RECOMMANDÉ

```text
1. Analyse du dépôt
2. Git
3. Firebase Core
4. Authentication
5. Firestore
6. Parcelles
7. Carnet
8. Diagnostic TFLite
9. Météo
10. NDVI
11. Gemini
12. UI Stitch
13. Tests
14. Sécurité
15. Performance
16. Build Android
17. Documentation
```

Si une étape existe déjà :

```text
vérifier
→ tester
→ conserver
→ passer à la suivante
```

---

# 60. PROMPT OPÉRATIONNEL FINAL

À partir de maintenant, considère ce fichier comme la **source de vérité du développement Agrivision RDC**.

Pour chaque demande de développement :

```text
ANALYSE LE PROJET RÉEL
↓
IDENTIFIE LES FICHIERS CONCERNÉS
↓
VÉRIFIE L'EXISTANT
↓
VÉRIFIE STITCH/MCP SI UI
↓
PLANIFIE LA MODIFICATION MINIMALE
↓
IMPLÉMENTE
↓
AJOUTE/ADAPTE LES TESTS
↓
FORMATE
↓
FLUTTER ANALYZE
↓
FLUTTER TEST
↓
BUILD SI NÉCESSAIRE
↓
VÉRIFIE LES SECRETS
↓
GIT STATUS
↓
GIT DIFF
↓
GIT ADD .
↓
GIT DIFF --CACHED
↓
GIT COMMIT
↓
GIT PUSH
↓
VÉRIFIE LE RÉSULTAT
↓
RAPPORT FINAL
```

### Règles non négociables

1. **Analyser avant de modifier.**
2. **Ne pas réinventer ce qui existe déjà.**
3. **Ne pas sur-ingénieriser le projet.**
4. **Tester toute modification importante.**
5. **Ne jamais exposer de secret.**
6. **Respecter les règles Firestore.**
7. **Vérifier réellement le MCP Stitch avant de prétendre l'utiliser.**
8. **Chaque modification validée doit être commitée.**
9. **Chaque modification validée doit être poussée.**
10. **Ne jamais déclarer une opération réussie sans vérification réelle.**

---

# 61. RÉFÉRENCE GOOGLE STITCH

```text
Project:
Agrivision RDC UI/UX Design

Project ID:
14882091670996114955

07 — Accueil Dashboard
17f60e5690d94a5cae40bf40cfda62f6

12 — Parcelles & Suivi NDVI
2ea087d1aa884beb98d8e3781eb1beae

15 — Diagnostic IA & Assistant
4fc44ca5604042648b6311053242e66c

Design System
asset-stub-assets_88c5944bfd714ff6a989c5861fa824c3

08 — Carnet de Culture
d36efd6cbda24e7c84e756ad58ac288b
```

---

# 62. ARCHITECTURE FINALE

```text
                         AGRIVISION RDC
                               │
                         Flutter / Dart
                               │
        ┌──────────────────────┼────────────────────────┐
        │                      │                        │
      Firebase              Firestore                Services
        │                      │                        │
     Auth UID          ┌───────┼────────┐       ┌──────┼──────┐
                       │       │        │       │      │      │
                   Parcelles Carnet Diagnostics Météo  NDVI Gemini
                                             │      │      │
                                        OpenWeather Agro   Google
                                                     Monitoring Gemini
                       │
                    TFLite
                       │
                 39 classes
```

---

# 63. OBJECTIF FINAL

Agrivision RDC doit devenir une application :

```text
fonctionnelle
simple
professionnelle
sécurisée
testable
maintenable
performante
visuellement cohérente
adaptée au contexte agricole congolais
```

Le niveau de sophistication doit venir de la **qualité de l'implémentation**, et non de la multiplication inutile des technologies.

**FIN DU MASTER PROMPT CODEX — AGRIVISION RDC**
