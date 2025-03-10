//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 10/3/25.
//

import Foundation

class HTMLStyleSheet {
    static let standard = """
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f7;
        }

        .header {
            background: linear-gradient(135deg, #0a84ff, #0066cc);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }

        .header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }

        .main-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #1d1d1f;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #0a84ff;
        }

        .component-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .component-item {
            background: #f8f8f8;
            border-radius: 8px;
            margin-bottom: 15px;
            overflow: hidden;
            display: flex;
            border-left: 4px solid #0a84ff;
        }

        .component-content {
            flex: 1;
            padding: 20px;
            border-left: 1px solid #eee;
        }

        .component-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .component-name {
            font-size: 16px;
            font-weight: 600;
            color: #1d1d1f;
        }

        .network-status {
            display: inline-block;
            padding: 4px 8px;
            margin-left: 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-success {
            background: #e4f8ef;
            color: #1d6f42;
        }

        .status-error {
            background: #fde8e8;
            color: #c81e1e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f5f5f7;
            font-weight: 600;
            color: #666;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #86868b;
            font-size: 14px;
        }
    """
    
    static func customCSS(_ customStyle: String? = nil) -> String {
        if let customStyle = customStyle {
            return """
            <style>
            \(standard)
            \(customStyle)
            </style>
            """
        } else {
            return """
            <style>
            \(standard)
            </style>
            """
        }
    }
}
