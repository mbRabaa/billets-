# Étape 1 : Construction du frontend React
FROM node:18 AS build_frontend
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend ./
RUN npm run build

# Étape 2 : Construction de l'image finale pour le backend Express
FROM node:18
WORKDIR /app

# Copier les fichiers du backend
COPY backend/package.json backend/package-lock.json ./
RUN npm install --only=production
COPY backend ./

# Copier le build React dans le backend (servi en statique par Express)
COPY --from=build_frontend /app/build ./public

# Exposer le port du backend
EXPOSE 5000

# Démarrer l'application Express
CMD ["node", "server.js"]
