document.addEventListener("DOMContentLoaded", function() {
  var analyticsRoot = document.getElementById('analytics');
  if (!analyticsRoot) { return; }

  Rails.ajax({
    type: 'GET',
    url: 'api/',
    success: function(data) { displayAnalytics(data); },
    error: function(err) { console.log(err); }
  })

  function diffDays(first, second) {
    var oneDay = 24*60*60*1000;
    var firstDate = new Date(first);
    var secondDate = second ? new Date(second) : new Date();
    return Math.round(Math.abs((firstDate.getTime() - secondDate.getTime())/(oneDay)));
  }

  function displayAnalytics(data) {
    console.log(data)
    
    // associate the charts with their html elements
    var countChart = dc.dataCount('#count-chart');
    var durationChart = dc.barChart("#duration-chart");
    var locationChart = dc.pieChart("#location-chart");

    // send data to crossfilter
    var ndx = crossfilter(data);

    // create dimensions
    var durationDimension = ndx.dimension(function(d) {
      return d.is_active ?
      diffDays(d.created_at, null) :
      diffDays(d.created_at, d.updated_at)
    });
    var locationDimension = ndx.dimension(function (d) { return d.location; });
    
    // create groups
    var all = ndx.groupAll();
    var durationSumGroup = durationDimension.group().reduceCount();
    var locationSumGroup = locationDimension.group().reduceCount();

    // create charts
    countChart
      .dimension(ndx)
      .group(all);

    durationChart
      .width(768)
      .height(480)
      .x(d3.scale.linear().domain([0,70]))
      .brushOn(false)
      .yAxisLabel("Free Hot Tubs!")
      .xAxisLabel("# of Days Available")
      .dimension(durationDimension)
      .group(durationSumGroup)
      .on('renderlet', function(chart) {
          chart.selectAll('rect').on("click", function(d) {
              console.log("click!", d);
          });
      });

    locationChart
      .width(400)
      .height(400)
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

    // render charts
    durationChart.render();
    countChart.render();
    locationChart.render();
  }

});