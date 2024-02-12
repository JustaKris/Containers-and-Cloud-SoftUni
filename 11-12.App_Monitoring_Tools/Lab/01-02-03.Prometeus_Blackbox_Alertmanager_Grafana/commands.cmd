echo off

::Running Prometheus in a container
docker run -p 9115:9115 quay.io/prometheus/blackbox-exporter

::Run Prometheus locally with a blackbox config file
"C:\Program Files\Prometheus-2.49.1\prometheus.exe" --config.file "prometheus-blackbox.yml"

::Run Alertmanager
"C:\Program Files\Alertmanager-0.26.0\alertmanager.exe" --config.file "alertmanager-blackbox.yml"