# Observability Setup

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Instrumenting the Application](#instrumenting-the-application)
   - [Installing OpenTelemetry SDK](#installing-opentelemetry-sdk)
   - [Configuring OpenTelemetry](#configuring-opentelemetry)
4. [Deploying OpenTelemetry Collector](#deploying-opentelemetry-collector)
   - [Kubernetes Manifest for Collector](#kubernetes-manifest-for-collector)
   - [ConfigMap for Collector Configuration](#configmap-for-collector-configuration)
5. [Configuring AKS Monitoring](#configuring-aks-monitoring)
   - [Enable Azure Monitor](#enable-azure-monitor)
6. [Viewing Metrics and Logs](#viewing-metrics-and-logs)
7. [Conclusion](#conclusion)

## Introduction
This document provides step-by-step instructions to set up observability for an AI application deployed on Azure Kubernetes Service (AKS) using OpenTelemetry. It includes capturing application traces, logs, and metrics and sending them to Azure Monitor and Application Insights.

## Prerequisites
- Azure Subscription
- AKS Cluster
- Application deployed on AKS
- Azure CLI installed

## Instrumenting the Application

### Installing OpenTelemetry SDK

#### For Python:
```bash
pip install opentelemetry-api
pip install opentelemetry-sdk
pip install opentelemetry-exporter-otlp
