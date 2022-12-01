//
//  ContentView.swift
//  SwiftChartsSample
//
//  Created by Rob Maltese on 11/30/22.
//

import SwiftUI
import Charts

struct OilPriceAverage: Identifiable {
    var id = UUID()
    var date: Date
    var price: Double
}

struct ContentView: View {
    let oilPriceAverage: [OilPriceAverage] = [
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 1), price: 2.50),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 2), price: 2.75),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 3), price: 2.00),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 4), price: 2.40),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 5), price: 2.65),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 6), price: 2.00),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 7), price: 2.25),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 8), price: 2.25),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 9), price: 2.25),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 10), price: 2.25),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 11), price: 2.14),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 12), price: 2.20),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 13), price: 2.10),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 14), price: 2.05),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 15), price: 1.95),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 16), price: 2.07),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 17), price: 2.10),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 18), price: 2.05),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 19), price: 2.03),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 20), price: 1.97),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 21), price: 1.93),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 22), price: 1.99),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 23), price: 2.09),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 24), price: 2.12),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 25), price: 2.15),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 26), price: 2.22),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 27), price: 2.25),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 28), price: 2.21),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 29), price: 2.18),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 30), price: 2.13),
        OilPriceAverage(date: Date.from(year: 2022, month: 11, day: 31), price: 2.10)
    ]

    var body: some View {
        VStack {
            GroupBox {
                Text("Weekly Average Price Chart")
                    .font(.headline)
                Text("Average $\(priceAverage, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                WeeklyChart
                ChartLegend
            }
            .frame(height: 350)
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    var WeeklyChart: some View {
        Chart {
            RuleMark(y: .value("Average", priceAverage))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))

            ForEach(oilPriceAverage) { oil in
                BarMark(
                    x: .value("Day", oil.date, unit: .weekSpan()),
                    y: .value("Price", oil.price)
                )
                .foregroundStyle(oil.isAbove(average: priceAverage) ? .red : .green)
            }
        }
        .chartYAxis {
            AxisMarks(format: .currency(code: "USD"), position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: oilPriceAverage.map {$0.date}) { date in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
    }

    var priceAverage: Double {
        let total = oilPriceAverage.reduce(0, {$0 + $1.price})
        return (total / Double(oilPriceAverage.count))
    }

    var ChartLegend: some View {
        HStack {
            Image(systemName: "line.diagonal")
                .rotationEffect(Angle(degrees: 45))
                .foregroundColor(.blue)
            Text("Average Price")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
        .font(.caption)

    }
}

extension OilPriceAverage {
    func isAbove(average: Double) -> Bool {
        self.price > average
    }
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }

    static func weekSpan() -> Date {
        let components = DateComponents(.current)
        return components.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
    }
}

/*

 Create data for a line chart comprised of pricing average over the last week.
    - Date
    - 100Gal Price Average

 */
