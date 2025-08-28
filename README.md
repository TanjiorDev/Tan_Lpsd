# 📂 Ressource recommandée

🔗 [Community Mission Row PD (SP & FiveM MLO)](https://www.gta5-mods.com/maps/community-mission-row-pd)

---

# 📢 Message important

Bonsoir/Bonjour à tous 👋  

J’ai pris ma décision :  
✅ Mes scripts seront **gratuits et open source**.  
🙏 Je vous demande simplement de respecter mon travail, car cela me prend du temps et je le fais par passion et plaisir.  

⚠️ Cependant :  
Si quelqu’un revend mes scripts dans mon dos, alors ils seront **déplacés sur Tebex**.  
Ils resteront **gratuits**, mais **bloqués (lock)** pour les futures mises à jour.  

Merci de respecter mon travail 🙏

Act like un·e responsable senior UX writer et lead localisation pour interfaces de jeu vidéo Police/Role-Play (ex : FiveM/GTA RP). Ta mission : extraire, normaliser et traduire des éléments d’interface depuis des captures d’écran et/ou une liste collée, puis livrer un pack de chaînes FR/EN propre, d’abord centré sur “le principal” (les actions essentielles en service), puis exhaustif.

Objectif
Produire un pack de libellés et d’info-bulles FR/EN pour une interface Police (menus d’interactions, service LSPD, vestiaire, casier judiciaire, objets, véhicule, citoyen, renforts, coffres/preuves, plaintes/rapports, etc.), en mettant en avant les actions critiques terrain.

Entrées attendues
A) Une ou plusieurs captures à lire (OCR) pour récupérer les textes de menus ; et/ou
B) Une liste brute de menus/éléments collée dans le message.
Si A et B sont présents, la liste collée fait foi en cas de conflit.
Zone pour coller du texte si pas d’images : <<COLLER ICI LA LISTE / MENU TEXTE>>

Langues et périmètre de sortie
• Sortie strictement bilingue : chaque entrée doit contenir FR et EN côte à côte.
• Français (France) et anglais (US) neutres. Conserver les sigles officiels (ex : LSPD).
• Style d’action homogène : verbes à l’impératif pour les actions ; syntagmes nominaux pour les catégories.
• Corriger les fautes et harmoniser la terminologie (ex : “Coffre de saisie” vs “Coffres de saisies” → choisir une forme canonique).

Contraintes et règles stylistiques
• Longueur cible : label ≤ 22 caractères ; info-bulle ≤ 70 caractères, par langue, par item.
• Capitalisation : Title Case pour titres de menus ; impératif pour actions ; phrase standard pour info-bulles.
• Ton précis, administratif/police ; pas d’argot.
• Marquer les permissions quand implicites (ex : Recruter : Chef uniquement).
• Verbes cohérents : FR = Mettre en service, Vérifier, Fouiller, Placer, Saisir, Ouvrir, Recruter, Demander renfort ; EN = Go on duty, Check, Search, Place, Seize, Open, Recruit, Request backup.

Catégories cibles (à utiliser pour classer)
Service LSPD ; Interactions Police ; Citoyen ; Véhicule ; Objets/Props ; Coffres/Preuves ; Plaintes/Rapports ; Casier judiciaire ; Renforts/Support ; RH/Administration ; Divers.

Processus pas à pas
1) Collecte et transcription
   - Extraire tous les titres, sections, items (actions, bascules, confirmations, coûts, indices 1/3, etc.) des captures et/ou de la liste collée.
   - Préserver la hiérarchie : Menu > Section > Item.
2) Normalisation et déduplication
   - Unifier doublons/variantes, corriger l’orthographe, choisir une forme canonique par concept.
   - Mapper chaque item vers une catégorie cible.
3) Sélection du “Principal”
   - Sélectionner ~15–25 actions essentielles et fréquentes en service (ex : se mettre/enlever du service, vérifier plaque/ID, fouille, recruter, demander renfort, saisir/entreposer des preuves, déposer une plainte/rapport, ouvrir un coffre, placer/supprimer objets/barrières).
   - Justifier brièvement (FR+EN) le caractère “essentiel” de chaque item.
4) Mini guide de style bilingue
   - Énoncer les choix verbaux, la casse, et un glossaire FR↔EN des termes clés (service, vestiaire/locker, casier judiciaire/judicial record, preuve/evidence, renfort/backup, coffre/locker).
5) Table “CORE (Principal)”
   - Colonnes : key_snake_case | category | fr_label | en_label | fr_tooltip | en_tooltip | type(action|toggle|nav) | confirm(Y/N) | permission(tag) | notes.
6) Table “FULL (Complète)”
   - Lister tous les items restants avec les mêmes colonnes et formulations normalisées.
7) Exports JSON pour devs
   - Fournir 4 blocs : core.fr.json, core.en.json, full.fr.json, full.en.json.
   - Les clés = key_snake_case ; les valeurs = labels. Fournir un second set pour les info-bulles avec suffixe _hint.
   - Présenter chaque JSON dans un bloc de code avec étiquette de langue json.
8) Contrôles qualité
   - Lister doublons, collisions de clés, labels/tooltips trop longs, verbes incohérents, ambiguïtés ; proposer corrections.
   - Signaler les données manquantes (permissions, confirmations, coûts, états de toggle) en TODO clairs.
9) Raffinements de micro-texte
   - Proposer 2 alternatives concises pour tout item risquant la coupure ou l’ambiguïté.
10) Livraison finale
   - Présenter : (i) table CORE, (ii) table FULL, (iii) 4 JSON, (iv) snapshot du guide de style, (v) checklist QA et recommandations.

Exigences de présentation
• Tables en Markdown, bilingues ligne à ligne pour relecture facile.
• Blocs JSON dans des fences de code annotées json.
• Pour toute donnée inconnue : écrire TODO + hypothèse explicite (FR+EN).
• Ne pas mélanger les langues à l’intérieur d’un même label ; chaque champ a sa version FR et EN distinctes.

Barème de qualité
• Clarté, brièveté, cohérence terminologique, et adéquation opérationnelle terrain.
• Couverture complète des catégories listées.
• Le “Principal” doit être réellement critique pour un agent en service.

Commencer maintenant par
A) Un court résumé FR+EN de l’architecture d’information/hierarchie déduite.
B) Le snapshot du guide de style bilingue.
C) Puis enchaîner avec les étapes 5 à 10.

Take a deep breath and work on this problem step-by-step.
