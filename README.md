# MealMaster

Le projet de mon app mobile pour les YDAYS 2024-2026

MealMaster est une application innovante et intuitive conçue pour simplifier la planification des repas et la gestion des courses. Elle permet aux utilisateurs de planifier leurs repas hebdomadaires, de générer automatiquement des listes de courses en fonction des recettes sélectionnées, et d'obtenir des informations sur les prix des aliments dans les supermarchés locaux. MealMaster vise à réduire le gaspillage alimentaire, à économiser du temps et à améliorer l'expérience culinaire de ses utilisateurs.

## Fonctionnalités Principales

- **Planification des Repas** :
    - Interface intuitive pour planifier les repas de la semaine.
    - Sélection de recettes à partir d'une vaste base de données.
    - Suggestions de recettes basées sur les préférences alimentaires et les ingrédients disponibles.

- **Liste de Courses Automatique** :
    - Génération automatique de la liste de courses basée sur les repas planifiés.
    - Organisation des articles par catégorie (fruits et légumes, viandes, produits laitiers, etc.).
    - Option pour ajouter des articles supplémentaires manuellement.

- **Base de Données de Recettes** :
    - Collection de recettes avec ingrédients, instructions, temps de préparation et nombre de portions.
    - Filtrage par type de repas (petit-déjeuner, déjeuner, dîner), régime alimentaire (végétarien, végan, sans gluten), et plus encore.
    - Intégration de recettes provenant de sources fiables et mises à jour régulièrement.

- **Gestion des Stocks** :
    - Suivi des ingrédients disponibles dans le garde-manger.
    - Déduction automatique des ingrédients utilisés dans les recettes planifiées.
    - Notifications pour les articles presque épuisés et nécessitant un réapprovisionnement.

- **Notifications et Rappels** :
    - Rappels pour la préparation des repas en avance.
    - Notifications pour vérifier et mettre à jour la liste de courses avant de faire les courses.
    - Alertes pour les offres spéciales et promotions dans les supermarchés locaux.

- **Informations sur les Prix** :
    - Accès aux prix des aliments dans les supermarchés locaux grâce à des API partenaires.
    - Comparaison des prix entre différents magasins pour économiser sur les achats.
    - Mises à jour régulières pour refléter les changements de prix et les nouvelles offres.

- **Interface Utilisateur (UI) et Expérience Utilisateur (UX)** :
    - Design moderne et épuré pour une navigation facile et agréable.
    - Composants réutilisables pour une expérience cohérente.
    - Accessibilité pour les utilisateurs avec des handicaps (contraste des couleurs, navigation au clavier, etc.).

## Technologies Utilisées

- **Frontend** :
    - Flutter pour une expérience utilisateur dynamique et réactive.

- **Backend** :
    - PocketBase pour la gestion des données et des requêtes.

- **Base de Données** :
    - PocketBase pour stocker les recettes, les ingrédients, les utilisateurs et autres données essentielles.

## Installation et Démarrage

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/mealmaster.git
   cd mealmaster
    ```

2. Installez les dépendances Flutter :

```bash

flutter pub get

```
3. Configurez PocketBase :

    Téléchargez et lancez PocketBase en suivant ce guide.
    Assurez-vous que PocketBase est accessible via http://192.168.0.28:80.

4. Démarrez l'application Flutter :

```bash

    flutter run

```
## Contribution

Les contributions sont les bienvenues ! Veuillez suivre les étapes suivantes pour contribuer :

    Fork le dépôt.
    Créez une branche de fonctionnalité (git checkout -b feature/nouvelle-fonctionnalité).
    Commitez vos modifications (git commit -am 'Ajoutez une nouvelle fonctionnalité').
    Poussez la branche (git push origin feature/nouvelle-fonctionnalité).
    Ouvrez une Pull Request.

## License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## Remerciements

    Flutter
    PocketBase

## Ressources

    Lab: Write your first Flutter app
    Cookbook: Useful Flutter samples
    Documentation en ligne de Flutter