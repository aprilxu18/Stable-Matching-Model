const d3 = require('d3')
d3.selectAll("svg > *").remove();

const PINK = "#ffbcd9";
const BLUE = "#a6e7ff";

STATE_HEIGHT = 220
BOX_WIDTH = 600
MARGIN = 100
numOfOneGender = instances[0].signature('Man').atoms(true).length
SPACING = (BOX_WIDTH - 2 * MARGIN) / (numOfOneGender - 1)

// Men
groupA = instances[0].atom("Match0").groupA.toString()
// Women
groupB = instances[0].atom("Match0").groupB.toString()


console.log(instances.map(function(inst) {
    console.log(inst.field('proposed').toString())
}));


states = 
     d3.select(svg)
     .selectAll('g') 
     .data(instances.map(function(d,i) {
        return {item: d, index: i}    
     }))
     .enter()   
     .append('g')
     .classed('state', true)
     .attr('id', d => d.index) 

states
    .append('rect')
    .attr('x', 10)
     .attr('y', function(d) {
         return 20 + STATE_HEIGHT * d.index
     })
    .attr('width', BOX_WIDTH)
    .attr('height', STATE_HEIGHT)
    .attr('stroke-width', 2)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');

states
    .append("text")
    .style("fill", "black")
     .attr('y', function(d) {
         return 40 + STATE_HEIGHT * d.index
     })
     .attr('x', 15)
     .text(d => "State "+ d.index);

peopleObjects = 
    states
    .selectAll('circle')
    .data(function(d) {        
        inst = d.item
        men = inst.signature('Man').tuples()
        women = inst.signature('Woman').tuples()

        hi = inst.atom('M0').proposed.toString()//.field('proposed').tuples()
        console.log("HERE")
        console.log(hi)

        people = men.concat(women)
        count = 0
        // currProposed = d.item
        // console.log(currProposed)
        return people.map(function(person) {

            currProposed = instances[1].atom('M0').proposed.toString()
            console.log(currProposed)

            preferences = inst.atom(person.toString()).preferences.tuples().join()
            // console.log(preferences)
            index = count % numOfOneGender
            if (groupA.includes(person.toString())) {
                gender = "male"
                y = 100 + d.index * STATE_HEIGHT
            } else {
                gender = "female"
                y = 170 + d.index * STATE_HEIGHT
            }
            count++
            return {item: person, 
                    index: index,
                    state: d.index,
                    gender: gender,
                    coords: {x: 49 + index * SPACING, y: y},
                    woman: {x: 49 + index * SPACING, y: 170 + d.index * STATE_HEIGHT},
                    preferences: preferences
                    }
        })
    })
    .enter()
    .append('g')
    .classed('people', true)

peopleObjects
    .append('circle')    
    .attr('index', d => d.index)
    .attr('state', d => d.state)
    .attr('item',  d => d.item)
    .attr('r', 20)
    .attr('cx', function(d) {
        if (d.gender === "male") {
            return 50 + d.index * SPACING
        } else {
            return 50 + d.index * SPACING
        }
    })
    .attr('cy', function(d) {
        if (d.gender === "male") {
            return 80 + d.state * STATE_HEIGHT
        } else {
            return 200 + d.state * STATE_HEIGHT
        }
    })
    .attr('stroke', 'gray')
    .attr("fill", function(d) {
        if (d.gender === "male") {
            return BLUE
        } else {
            return PINK
        }
    });

peopleObjects
    .append('text')
     .attr('y', function(d) {
        if (d.gender === "male") {
            return 85 + d.state * STATE_HEIGHT
        } else {
            return 205 + d.state * STATE_HEIGHT
        }
     })
     .attr('x', function(d) {
        if (d.gender === "male") {
            return 39 + d.index * SPACING
        } else {
            return 39 + d.index * SPACING
        }
     })
     .text(function(d) {
        if (d.gender === "male") {
            return 'M' + d.index
        } else {
            return 'W' + d.index
        }
     });

peopleObjects
    .append('text')
     .attr('y', function(d) {
        if (d.gender === "male") {
            return 55 + d.state * STATE_HEIGHT
        } else {
            return 230 + d.state * STATE_HEIGHT
        }
     })
     .attr('x', function(d) {
        if (d.gender === "male") {
            return 15 + d.index * SPACING
        } else {
            return 15 + d.index * SPACING
        }
     })
     .style("font", "10px times")
     .text(function(d) {
        return d.preferences
     });

// https://observablehq.com/@harrylove/draw-an-arrow-between-circles-with-d3-links
const markerBoxWidth = 20;
  const markerBoxHeight = 20;
  const refX = markerBoxWidth / 2;
  const refY = markerBoxHeight / 2;
  const markerWidth = markerBoxWidth / 2;
  const markerHeight = markerBoxHeight / 2;
  const arrowPoints = [[0, 0], [0, 20], [20, 10]];

peopleObjects
    .append('defs')
    .append('marker')
    .attr('id', 'arrow')
    .attr('viewBox', [0, 0, markerBoxWidth, markerBoxHeight])
    .attr('refX', refX)
    .attr('refY', refY)
    .attr('markerWidth', markerBoxWidth)
    .attr('markerHeight', markerBoxHeight)
    .attr('orient', 'auto-start-reverse')
    .append('path')
    .attr('d', d3.line()(arrowPoints))
    .attr('stroke', 'black');

peopleObjects
    .append('path')
    .attr('d', function(d) {
        if (d.gender === "male") {
            return d3
            .linkVertical()
            .x(d => d.x)
            .y(d => d.y)({
            source: d.coords,
            target: d.woman
            });
        }
    })
    .attr('marker-end', 'url(#arrow)')
    .attr('stroke', 'black')
    .attr('fill', 'none');
