echo off

::Run Blackbox Exporter -> localhost:9115
"C:\Program Files\blackbox-exporter-0.24.0\blackbox_exporter.exe"

::Run Prometheus locally with a blackbox config file -> localhost:9090
"C:\Program Files\Prometheus-2.49.1\prometheus.exe" --config.file "prometheus-exam.yml"

::Run Alertmanager
"C:\Program Files\Alertmanager-0.26.0\alertmanager.exe" --config.file "alertmanager-exam.yml"

::Grafana -> localhost:3000 (make sure it's turned on in Services)