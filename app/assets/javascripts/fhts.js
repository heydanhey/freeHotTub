document.addEventListener("DOMContentLoaded", function() {
  var analyticsRoot = document.getElementById('root');
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
    var ndx = crossfilter(data),
      durationDimension = ndx.dimension(function(d) {
          return d.is_active ?
            diffDays(d.created_at, null) :
            diffDays(d.created_at, d.updated_at)
        }),
      durationSumGroup = durationDimension.group().reduceCount();

    var chart = dc.barChart("#root");
    chart
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
    chart.render();
  }

});