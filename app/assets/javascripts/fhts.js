document.addEventListener("DOMContentLoaded", function() {

  var analyticsRoot = document.getElementById('analytics');
  if (!analyticsRoot) { return; }

  const app = new Vue ({
    el: "#analytics",
    data: {
      fhts: []
    },
    created: function () {
      fetch('/api')
      .then(response => response.json())
      .then(data => {
        this.fhts = data
        this.displayAnalytics(this.fhts)
      })
    },
    methods: {
      diffDays (first, second) {
        var oneDay = 24*60*60*1000
        var firstDate = new Date(first)
        var secondDate = second ? new Date(second) : new Date()
        return Math.round(Math.abs((firstDate.getTime() - secondDate.getTime())/(oneDay)))
      },
      displayAnalytics (data) {
        // associate the charts with their html elements
        var countChart = dc.dataCount('#count-chart');
        var durationChart = dc.barChart("#duration-chart");
        var locationChart = dc.pieChart("#location-chart");

        // send data to crossfilter
        var ndx = crossfilter(data);

        // create dimensions
        var durationDimension = ndx.dimension(d => {
          return d.is_active ?
          this.diffDays(d.created_at, null) :
          this.diffDays(d.created_at, d.updated_at)
        });

        var locationDimension = ndx.dimension(d => d.location);

        // create groups
        var all = ndx.groupAll();
        var durationSumGroup = durationDimension.group().reduceCount();
        var locationSumGroup = locationDimension.group().reduceCount();

        // create charts
        countChart
          .dimension(ndx)
          .group(all);

        durationChart
          .width(450)
          .height(350)
          .x(d3.scale.linear().domain([0,70]))
          .yAxisLabel("Free Hot Tubs!")
          .xAxisLabel("# of Days Available")
          .dimension(durationDimension)
          .group(durationSumGroup)

        locationChart
          .width(400)
          .cx(75)
          .cy(125)
          .radius(75)
          .innerRadius(50)
          .dimension(locationDimension)
          .group(locationSumGroup)
          .transitionDuration(900)
          .legend(dc.legend().x(0).y(5).itemHeight(10).gap(3))
          .renderLabel(false)
          .renderTitle(false);

        //render charts
        durationChart.render();
        countChart.render();
        locationChart.render();
      }
    }
  })
})