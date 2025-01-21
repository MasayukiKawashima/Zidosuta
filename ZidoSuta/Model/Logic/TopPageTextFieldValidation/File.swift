//
//  File.swift
//  DietApp
//
//  Created by 川島真之 on 2024/11/08.
//


rotocol CompositeWeightValidator: WeightValidator {
  var validators: [WeightValidator] { get }
}