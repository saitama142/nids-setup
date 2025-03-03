class Dashboard {
  constructor() {
    this.initCharts();
    this.initEventListeners();
    this.startDataUpdates();
  }

  initCharts() {
    this.trafficCanvas = document.getElementById('trafficCanvas');
    this.ctx = this.trafficCanvas.getContext('2d');
    
    this.trafficChart = new ChartHelper(this.ctx, {
      type: 'line',
      data: this.generateTrafficData(),
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    });
  }

  initEventListeners() {
    document.getElementById('refreshAlerts').addEventListener('click', () => 
      this.updateAlerts());
    
    document.querySelector('.close').addEventListener('click', () => 
      this.toggleModal(false));
  }

  startDataUpdates() {
    setInterval(() => {
      this.updateTrafficChart();
      this.updateStatusIndicators();
    }, 5000);
  }

  generateTrafficData() {
    return {
      labels: Array(24).fill().map((_,i) => `${i}:00`),
      datasets: [{
        label: 'Network Traffic (Mbps)',
        data: Array(24).fill().map(() => Math.random() * 100),
        borderColor: '#3498db',
        tension: 0.4
      }]
    };
  }

  updateTrafficChart() {
    const newData = this.generateTrafficData().datasets[0].data;
    this.trafficChart.updateDataset(0, newData);
  }

  updateStatusIndicators() {
    document.getElementById('throughput').textContent = 
      `${(Math.random() * 100).toFixed(1)} Mbps`;
    
    document.getElementById('alertCount').textContent = 
      Math.floor(Math.random() * 50);
  }

  updateAlerts() {
    const alerts = [
      { type: 'ET SCAN Potential SSH Scan', count: 15 },
      { type: 'ET DROP Dshield Block List', count: 8 },
      { type: 'ET WEB_SERVER Possible SQL Injection', count: 3 }
    ];

    const alertList = document.getElementById('alertList');
    alertList.innerHTML = alerts.map(alert => `
      <div class="alert-item">
        <h4>${alert.type}</h4>
        <span>${alert.count} occurrences</span>
      </div>
    `).join('');
  }

  toggleModal(show = true) {
    document.getElementById('logModal').style.display = 
      show ? 'block' : 'none';
  }
}

class ChartHelper {
  constructor(ctx, config) {
    this.ctx = ctx;
    this.config = config;
    this.initChart();
  }

  initChart() {
    this.chart = new Chart(this.ctx, {
      type: this.config.type,
      data: this.config.data,
      options: this.config.options
    });
  }

  updateDataset(index, newData) {
    this.chart.data.datasets[index].data = newData;
    this.chart.update();
  }
}

// Initialize dashboard when DOM loads
document.addEventListener('DOMContentLoaded', () => new Dashboard());
