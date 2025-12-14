# Stage 1: Build React App
FROM node:18-alpine as build-step
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
# Đặt biến môi trường API URL trỏ về backend chạy local
ENV REACT_APP_API_URL=http://localhost:8000/api
RUN npm run build

# Stage 2: Serve bằng Nginx (Nhẹ, chuẩn production)
FROM nginx:alpine
COPY --from=build-step /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]