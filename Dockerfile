# .NET Coreの実行環境のイメージ
#FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
#FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled AS base
ARG REPO=mcr.microsoft.com/dotnet/aspnet
FROM $REPO:8.0.0-alpine3.18-amd64 AS base

WORKDIR /app

# 5000ポートで受け付けるように設定する
ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000

# .NET Coreのビルド環境のイメージ
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.18 AS publish
#FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS publish
# ビルド環境のイメージを 'amd64' に変更
#FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS publish

#FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.18-amd64 AS publish

WORKDIR /src
COPY . .

# ビルド環境でソースコードをビルドし、実行に必要な依存関係を含めて出力
RUN dotnet publish -c Release -o /out

FROM base AS final
WORKDIR /app

# .NET Coreの実行環境へビルド結果をコピーする
COPY --from=publish /out .

# .NET Coreのアプリを実行する
CMD ["dotnet", "/app/helloworld_netcore.dll"]