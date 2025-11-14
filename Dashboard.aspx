
<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 4;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 95px 20px 20px;
            text-align: center;
            background: transparent;
            position: relative;
            z-index: 2;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        /* Dropdown background color when clicked */
        .filter-control:focus, 
        .filter-control:active {
            background-color: #fffacd !important;
            border-color: #ffeb3b !important;
            color: #333 !important;
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        /* Contact Number Styles */
        .contact-number {
            background: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(40, 167, 69, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        .contact-locked {
            background: rgba(108, 117, 125, 0.2);
            color: rgba(255,255,255,0.6);
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        /* View Contact button background color */
        .view-contact-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            color: white !important;
            border: none !important;
            border-radius: 15px !important;
            padding: 8px 15px !important;
            font-size: 0.8rem !important;
            font-weight: 600 !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            margin-top: 5px !important;
            display: block !important;
            width: 100% !important;
        }

        .view-contact-btn:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4) !important;
            background: linear-gradient(135deg, #218838 0%, #1e9e6f 100%) !important;
        }

        .membership-tag {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: bold;
            margin-left: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        
        .tag-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .tag-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }
        
        .tag-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }
        
        .tag-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                            <span id="userMembershipTag" runat="server" class="membership-tag tag-free">Free</span>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <asp:Label ID="remainingMessages" runat="server" Text="5"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <asp:Label ID="remainingInterests" runat="server" Text="2"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and view contact numbers
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Religion (धर्म)</div>
                                <asp:DropDownList ID="ddlReligion" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Religion</asp:ListItem>
                                    <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                                    <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                                    <asp:ListItem Value="Christian">Christian</asp:ListItem>
                                    <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                                    <asp:ListItem Value="Jain">Jain</asp:ListItem>
                                    <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>

                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                                <span class='<%# "membership-tag " + GetMembershipTagClass(Eval("MembershipType")) %>'>
                                                    <%# Eval("MembershipType") %>
                                                </span>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-education marathi-font" style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-bottom: 8px;">
                                                <i class="fas fa-graduation-cap"></i> 
                                                <%# Eval("Education") %>
                                            </div>
                                            <div class="profile-religion marathi-font" style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-bottom: 15px;">
                                                <i class="fas fa-pray"></i> 
                                                <%# Eval("Religion") %>
                                            </div>
                                            
                                            <!-- Contact Number Section -->
                                            <div class="contact-section">
                                                <div class="contact-number" id="contactNumberDisplay" runat="server" style="display: none;">
                                                    <i class="fas fa-phone"></i> 
                                                    <asp:Literal ID="ltContactNumber" runat="server"></asp:Literal>
                                                </div>
                                                <div class="contact-locked" id="contactLocked" runat="server" style="display: none;">
                                                    <i class="fas fa-lock"></i> 
                                                    Upgrade to view contact number
                                                </div>
                                                <button class="view-contact-btn marathi-font" onclick='viewContactNumber(event, <%# Eval("UserID") %>, "<%# Eval("Phone") %>")'>
                                                    <i class="fas fa-eye"></i> View Contact
                                                </button>
                                            </div>
                                            
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserMembership" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // View Contact Number with Membership Check
        function viewContactNumber(event, profileUserID, phoneNumber) {
            event.stopPropagation();
            event.preventDefault();

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            const currentUserMembership = document.getElementById('<%= hdnCurrentUserMembership.ClientID %>').value;

            // Check if user has Silver, Gold, or Platinum membership
            const canViewContact = currentUserMembership === 'Silver' || 
                                  currentUserMembership === 'Gold' || 
                                  currentUserMembership === 'Platinum';

            if (canViewContact) {
                // Show contact number
                const contactSection = event.target.closest('.contact-section');
                const contactDisplay = contactSection.querySelector('.contact-number');
                const contactLocked = contactSection.querySelector('.contact-locked');
                const viewButton = contactSection.querySelector('.view-contact-btn');
                
                if (contactDisplay && phoneNumber && phoneNumber !== '') {
                    contactDisplay.style.display = 'block';
                    if (contactLocked) contactLocked.style.display = 'none';
                    if (viewButton) viewButton.style.display = 'none';
                    
                    // Log contact view
                    logContactView(currentUserID, profileUserID);
                } else {
                    // Contact number not available
                    if (contactLocked) {
                        contactLocked.style.display = 'block';
                        contactLocked.innerHTML = '<i class="fas fa-info-circle"></i> Contact number not available';
                    }
                    if (viewButton) viewButton.style.display = 'none';
                }
            } else {
                // Redirect to membership page
                if (confirm('You need a Silver, Gold, or Platinum membership to view contact numbers. Would you like to upgrade?')) {
                    window.location.href = 'Membership.aspx';
                }
            }
        }

        // Log contact view
        function logContactView(viewerUserID, profileUserID) {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/LogContactView",
                data: JSON.stringify({
                    viewerUserID: parseInt(viewerUserID),
                    profileUserID: parseInt(profileUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Contact view logged successfully');
                },
                error: function () {
                    console.log('Error logging contact view');
                }
            });
        }

        // Make quick stats sections clickable
        function initializeClickableSections() {
            // Main stats cards - clickable
            const mainStatsCards = document.querySelectorAll('.quick-stats-header .stat-card');
            if (mainStatsCards.length >= 4) {
                // Total Views
                mainStatsCards[0].style.cursor = 'pointer';
                mainStatsCards[0].addEventListener('click', function () {
                    window.location.href = 'TotalViews.aspx';
                });

                // Total Interests
                mainStatsCards[1].style.cursor = 'pointer';
                mainStatsCards[1].addEventListener('click', function () {
                    window.location.href = 'Interests.aspx';
                });

                // Today's Matches
                mainStatsCards[2].style.cursor = 'pointer';
                mainStatsCards[2].addEventListener('click', function () {
                    window.location.href = 'Matches.aspx';
                });

                // New Messages
                mainStatsCards[3].style.cursor = 'pointer';
                mainStatsCards[3].addEventListener('click', function () {
                    window.location.href = 'Messages.aspx';
                });
            }

            // Left sidebar stats boxes - clickable
            const leftStatsBoxes = document.querySelectorAll('.quick-stats .stat-box');
            if (leftStatsBoxes.length >= 4) {
                // Views
                leftStatsBoxes[0].style.cursor = 'pointer';
                leftStatsBoxes[0].addEventListener('click', function () {
                    window.location.href = 'TotalViews.aspx';
                });

                // Interests Received
                leftStatsBoxes[1].style.cursor = 'pointer';
                leftStatsBoxes[1].addEventListener('click', function () {
                    window.location.href = 'Interests.aspx?type=received';
                });

                // Interests Sent
                leftStatsBoxes[2].style.cursor = 'pointer';
                leftStatsBoxes[2].addEventListener('click', function () {
                    window.location.href = 'Interests.aspx?type=sent';
                });

                // Messages
                leftStatsBoxes[3].style.cursor = 'pointer';
                leftStatsBoxes[3].addEventListener('click', function () {
                    window.location.href = 'Messages.aspx';
                });
            }
        }

        // Send Interest with Block Check and Membership Limit Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining interests
            const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
            if (remainingInterests <= 0) {
                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;

                                // Update remaining interests count
                                const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check and Membership Limit Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining messages
            const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
            if (remainingMessages <= 0) {
                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;

                                // Update remaining messages count
                                const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

        // Notification Functions
        function initializeNotifications() {
            loadNotifications();
            setInterval(loadNotifications, 30000); // Refresh every 30 seconds
            
            // Notification bell click event
            $('#btnNotificationBell').click(function(e) {
                e.stopPropagation();
                $('#notificationDropdown').toggle();
            });
            
            // Mark all as read
            $('#btnMarkAllRead').click(function() {
                markAllNotificationsAsRead();
            });
            
            // Close dropdown when clicking outside
            $(document).click(function() {
                $('#notificationDropdown').hide();
            });
        }

        function loadNotifications() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetNotifications",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        const data = JSON.parse(response.d);
                        updateNotificationUI(data);
                    }
                },
                error: function () {
                    console.log('Error loading notifications');
                }
            });
        }

        function updateNotificationUI(data) {
            // Update badge counts
            if (data.TotalUnread > 0) {
                $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
            } else {
                $('#<%= totalNotificationBadge.ClientID %>').hide();
            }
            
            if (data.UnreadInterests > 0) {
                $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
            } else {
                $('#<%= interestNotification.ClientID %>').hide();
            }
            
            if (data.UnreadMessages > 0) {
                $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
            } else {
                $('#<%= messageNotification.ClientID %>').hide();
            }
            
            // Update notification list
            const notificationList = $('#notificationList');
            notificationList.empty();
            
            if (data.Notifications.length === 0) {
                notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
            } else {
                data.Notifications.forEach(notification => {
                    const notificationItem = $(`
                        <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                            <div class="notification-content">${notification.Message}</div>
                            <div class="notification-time">${notification.TimeAgo}</div>
                        </div>
                    `);
                    
                    notificationItem.click(function() {
                        markNotificationAsRead(notification.NotificationID);
                        handleNotificationClick(notification);
                    });
                    
                    notificationList.append(notificationItem);
                });
            }
        }

        function markNotificationAsRead(notificationID) {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkNotificationAsRead",
                data: JSON.stringify({
                    notificationID: notificationID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        // Remove the unread style
                        $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                        loadNotifications(); // Refresh counts
                    }
                }
            });
        }

        function markAllNotificationsAsRead() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkAllNotificationsAsRead",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        loadNotifications();
                        showNotification('All notifications marked as read!', 'success');
                    }
                }
            });
        }

        function handleNotificationClick(notification) {
            // Handle navigation based on notification type
            switch (notification.Type) {
                case 'Interest':
                    window.location.href = 'Interests.aspx';
                    break;
                case 'Message':
                    window.location.href = 'Messages.aspx';
                    break;
                case 'Shortlist':
                    window.location.href = 'Shortlisted.aspx';
                    break;
                case 'ProfileView':
                    window.location.href = 'TotalViews.aspx';
                    break;
                default:
                    // Do nothing
                    break;
            }

            // Close dropdown
            $('#notificationDropdown').hide();
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            initializeNotifications();
            initializeClickableSections();
            console.log('Dashboard loaded successfully');
        });
    </script>
</asp:Content>
















<%--<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 4;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 95px 20px 20px;
            text-align: center;
            background: transparent;
            position: relative;
            z-index: 2;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <asp:Label ID="remainingMessages" runat="server" Text="5"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <asp:Label ID="remainingInterests" runat="server" Text="2"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and premium features
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                    <asp:ListItem Value="Doctorate">Doctorate</asp:ListItem>
                                    <asp:ListItem Value="Diploma">Diploma</asp:ListItem>
                                    <asp:ListItem Value="HSC">HSC</asp:ListItem>
                                    <asp:ListItem Value="SSC">SSC</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Religion (धर्म)</div>
                                <asp:DropDownList ID="ddlReligion" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Religion</asp:ListItem>
                                    <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                                    <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                                    <asp:ListItem Value="Christian">Christian</asp:ListItem>
                                    <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                                    <asp:ListItem Value="Jain">Jain</asp:ListItem>
                                    <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-education marathi-font" style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-bottom: 8px;">
                                                <i class="fas fa-graduation-cap"></i> 
                                                <%# Eval("Education") %>
                                            </div>
                                            <div class="profile-religion marathi-font" style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-bottom: 15px;">
                                                <i class="fas fa-pray"></i> 
                                                <%# Eval("Religion") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
<script>
    // View Profile
    function viewProfile(userID) {
        window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
    }

    // Make quick stats sections clickable
    function initializeClickableSections() {
        // Main stats cards - clickable
        const mainStatsCards = document.querySelectorAll('.quick-stats-header .stat-card');
        if (mainStatsCards.length >= 4) {
            // Total Views
            mainStatsCards[0].style.cursor = 'pointer';
            mainStatsCards[0].addEventListener('click', function () {
                window.location.href = 'TotalViews.aspx';
            });

            // Total Interests
            mainStatsCards[1].style.cursor = 'pointer';
            mainStatsCards[1].addEventListener('click', function () {
                window.location.href = 'Interests.aspx';
            });

            // Today's Matches
            mainStatsCards[2].style.cursor = 'pointer';
            mainStatsCards[2].addEventListener('click', function () {
                window.location.href = 'Matches.aspx';
            });

            // New Messages
            mainStatsCards[3].style.cursor = 'pointer';
            mainStatsCards[3].addEventListener('click', function () {
                window.location.href = 'Messages.aspx';
            });
        }

        // Left sidebar stats boxes - clickable
        const leftStatsBoxes = document.querySelectorAll('.quick-stats .stat-box');
        if (leftStatsBoxes.length >= 4) {
            // Views
            leftStatsBoxes[0].style.cursor = 'pointer';
            leftStatsBoxes[0].addEventListener('click', function () {
                window.location.href = 'TotalViews.aspx';
            });

            // Interests Received
            leftStatsBoxes[1].style.cursor = 'pointer';
            leftStatsBoxes[1].addEventListener('click', function () {
                window.location.href = 'Interests.aspx?type=received';
            });

            // Interests Sent
            leftStatsBoxes[2].style.cursor = 'pointer';
            leftStatsBoxes[2].addEventListener('click', function () {
                window.location.href = 'Interests.aspx?type=sent';
            });

            // Messages
            leftStatsBoxes[3].style.cursor = 'pointer';
            leftStatsBoxes[3].addEventListener('click', function () {
                window.location.href = 'Messages.aspx';
            });
        }
    }

    // Send Interest with Block Check and Membership Limit Check
    function sendInterest(event, toUserID) {
        event.stopPropagation();
        event.preventDefault();

        // Check remaining interests
        const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
        if (remainingInterests <= 0) {
            showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
            return;
        }

        // First check if user is blocked
        checkIfBlocked(toUserID, function (isBlocked) {
            if (isBlocked) {
                showNotification('You cannot send interest to a blocked user!', 'error');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = event.target.closest('.btn-interest') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: toUserID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = 'rgba(40, 167, 69, 0.8)';
                            button.disabled = true;

                            // Update remaining interests count
                            const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                            remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                            showNotification('Interest sent successfully!', 'success');
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = 'rgba(255, 193, 7, 0.8)';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else if (response.d === "blocked") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Cannot send interest to blocked user!', 'error');
                        } else if (response.d === "limit_reached") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        });
    }

    // Send Message with Block Check and Membership Limit Check
    function sendMessage(event, toUserID) {
        event.stopPropagation();
        event.preventDefault();

        // Check remaining messages
        const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
        if (remainingMessages <= 0) {
            showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
            return;
        }

        // First check if user is blocked
        checkIfBlocked(toUserID, function (isBlocked) {
            if (isBlocked) {
                showNotification('You cannot send message to a blocked user!', 'error');
                return;
            }

            const message = prompt('Enter your message:');
            if (message) {
                const button = event.target.closest('.btn-message') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: toUserID,
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = 'rgba(40, 167, 69, 0.8)';
                            button.disabled = true;

                            // Update remaining messages count
                            const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                            remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                            showNotification('Message sent successfully!', 'success');
                        } else if (response.d === "blocked") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Cannot send message to blocked user!', 'error');
                        } else if (response.d === "limit_reached") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            }
        });
    }

    // Check if user is blocked
    function checkIfBlocked(targetUserID, callback) {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/CheckIfBlocked",
            data: JSON.stringify({
                currentUserID: parseInt(currentUserID),
                targetUserID: targetUserID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                callback(response.d);
            },
            error: function () {
                callback(false);
            }
        });
    }

    // Shortlist Profile
    function shortlistProfile(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        const button = event.target.closest('.btn-shortlist') || event.target;
        const originalText = button.innerHTML;
        button.innerHTML = '⏳ Shortlisting...';
        button.disabled = true;

        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/ShortlistProfile",
            data: JSON.stringify({
                userID: parseInt(currentUserID),
                shortlistedUserID: userID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    button.innerHTML = '✅ Shortlisted';
                    button.style.background = 'rgba(40, 167, 69, 0.8)';
                    button.disabled = true;
                    showNotification('Profile shortlisted successfully!', 'success');
                } else if (response.d === "exists") {
                    button.innerHTML = '✅ Already Shortlisted';
                    button.style.background = 'rgba(255, 193, 7, 0.8)';
                    button.disabled = true;
                    showNotification('You have already shortlisted this profile!', 'info');
                } else {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            },
            error: function () {
                button.innerHTML = originalText;
                button.disabled = false;
                showNotification('Error shortlisting!', 'error');
            }
        });
    }

    // Block User Function
    function blockUser(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
            const button = event.target.closest('.btn-block') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Blocking...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/BlockUser",
                data: JSON.stringify({
                    blockedByUserID: parseInt(currentUserID),
                    blockedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Blocked';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('User blocked successfully!', 'success');

                        // Remove the profile card from view
                        setTimeout(() => {
                            const profileCard = event.target.closest('.profile-card');
                            if (profileCard) {
                                profileCard.style.opacity = '0.5';
                                profileCard.style.pointerEvents = 'none';
                            }
                        }, 1000);
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Blocked';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('You have already blocked this user!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error blocking user!', 'error');
                }
            });
        }
    }

    // Report User Function
    function reportUser(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        const reportReason = prompt('Please specify the reason for reporting this profile:');
        if (reportReason) {
            const button = event.target.closest('.btn-report') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Reporting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ReportUser",
                data: JSON.stringify({
                    reportedByUserID: parseInt(currentUserID),
                    reportedUserID: userID,
                    reportReason: reportReason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Reported';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('User reported successfully! Our team will review this profile.', 'success');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error reporting user!', 'error');
                }
            });
        }
    }

    // Notification Functions
    function initializeNotifications() {
        loadNotifications();
        setInterval(loadNotifications, 30000); // Refresh every 30 seconds

        // Notification bell click event
        $('#btnNotificationBell').click(function (e) {
            e.stopPropagation();
            $('#notificationDropdown').toggle();
        });

        // Mark all as read
        $('#btnMarkAllRead').click(function () {
            markAllNotificationsAsRead();
        });

        // Close dropdown when clicking outside
        $(document).click(function () {
            $('#notificationDropdown').hide();
        });
    }

    function loadNotifications() {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/GetNotifications",
            data: JSON.stringify({
                userID: parseInt(currentUserID)
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d) {
                    const data = JSON.parse(response.d);
                    updateNotificationUI(data);
                }
            },
            error: function () {
                console.log('Error loading notifications');
            }
        });
    }

    function updateNotificationUI(data) {
        // Update badge counts
        if (data.TotalUnread > 0) {
            $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
        } else {
            $('#<%= totalNotificationBadge.ClientID %>').hide();
        }

        if (data.UnreadInterests > 0) {
            $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
        } else {
            $('#<%= interestNotification.ClientID %>').hide();
        }

        if (data.UnreadMessages > 0) {
            $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
        } else {
            $('#<%= messageNotification.ClientID %>').hide();
        }

        // Update notification list
        const notificationList = $('#notificationList');
        notificationList.empty();

        if (data.Notifications.length === 0) {
            notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
        } else {
            data.Notifications.forEach(notification => {
                const notificationItem = $(`
                    <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                        <div class="notification-content">${notification.Message}</div>
                        <div class="notification-time">${notification.TimeAgo}</div>
                    </div>
                `);

                notificationItem.click(function () {
                    markNotificationAsRead(notification.NotificationID);
                    handleNotificationClick(notification);
                });

                notificationList.append(notificationItem);
            });
        }
    }

    function markNotificationAsRead(notificationID) {
        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/MarkNotificationAsRead",
            data: JSON.stringify({
                notificationID: notificationID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    // Remove the unread style
                    $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                    loadNotifications(); // Refresh counts
                }
            }
        });
    }

    function markAllNotificationsAsRead() {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/MarkAllNotificationsAsRead",
            data: JSON.stringify({
                userID: parseInt(currentUserID)
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    loadNotifications();
                    showNotification('All notifications marked as read!', 'success');
                }
            }
        });
    }

    function handleNotificationClick(notification) {
        // Handle navigation based on notification type
        switch (notification.Type) {
            case 'Interest':
                window.location.href = 'Interests.aspx';
                break;
            case 'Message':
                window.location.href = 'Messages.aspx';
                break;
            case 'Shortlist':
                window.location.href = 'Shortlisted.aspx';
                break;
            case 'ProfileView':
                window.location.href = 'TotalViews.aspx';
                break;
            default:
                // Do nothing
                break;
        }

        // Close dropdown
        $('#notificationDropdown').hide();
    }

    // Notification function
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.padding = '15px 20px';
        notification.style.borderRadius = '10px';
        notification.style.color = 'white';
        notification.style.fontWeight = 'bold';
        notification.style.zIndex = '10000';
        notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
        notification.style.backdropFilter = 'blur(10px)';
        notification.style.border = '1px solid rgba(255,255,255,0.2)';

        if (type === 'success') {
            notification.style.background = 'rgba(40, 167, 69, 0.8)';
        } else if (type === 'error') {
            notification.style.background = 'rgba(220, 53, 69, 0.8)';
        } else if (type === 'info') {
            notification.style.background = 'rgba(23, 162, 184, 0.8)';
        }

        notification.innerHTML = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 3000);
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', function () {
        initializeNotifications();
        initializeClickableSections();
        console.log('Dashboard loaded successfully');
    });
</script>
</asp:Content>--%>























<%--<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 4;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 95px 20px 20px;
            text-align: center;
            background: transparent;
            position: relative;
            z-index: 2;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <asp:Label ID="remainingMessages" runat="server" Text="5"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <asp:Label ID="remainingInterests" runat="server" Text="2"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and premium features
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
<script>
    // View Profile
    function viewProfile(userID) {
        window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
    }

    // Make quick stats sections clickable
    function initializeClickableSections() {
        // Main stats cards - clickable
        const mainStatsCards = document.querySelectorAll('.quick-stats-header .stat-card');
        if (mainStatsCards.length >= 4) {
            // Total Views
            mainStatsCards[0].style.cursor = 'pointer';
            mainStatsCards[0].addEventListener('click', function () {
                window.location.href = 'TotalViews.aspx';
            });

            // Total Interests
            mainStatsCards[1].style.cursor = 'pointer';
            mainStatsCards[1].addEventListener('click', function () {
                window.location.href = 'Interests.aspx';
            });

            // Today's Matches
            mainStatsCards[2].style.cursor = 'pointer';
            mainStatsCards[2].addEventListener('click', function () {
                window.location.href = 'Matches.aspx';
            });

            // New Messages
            mainStatsCards[3].style.cursor = 'pointer';
            mainStatsCards[3].addEventListener('click', function () {
                window.location.href = 'Messages.aspx';
            });
        }

        // Left sidebar stats boxes - clickable
        const leftStatsBoxes = document.querySelectorAll('.quick-stats .stat-box');
        if (leftStatsBoxes.length >= 4) {
            // Views
            leftStatsBoxes[0].style.cursor = 'pointer';
            leftStatsBoxes[0].addEventListener('click', function () {
                window.location.href = 'TotalViews.aspx';
            });

            // Interests Received
            leftStatsBoxes[1].style.cursor = 'pointer';
            leftStatsBoxes[1].addEventListener('click', function () {
                window.location.href = 'Interests.aspx?type=received';
            });

            // Interests Sent
            leftStatsBoxes[2].style.cursor = 'pointer';
            leftStatsBoxes[2].addEventListener('click', function () {
                window.location.href = 'Interests.aspx?type=sent';
            });

            // Messages
            leftStatsBoxes[3].style.cursor = 'pointer';
            leftStatsBoxes[3].addEventListener('click', function () {
                window.location.href = 'Messages.aspx';
            });
        }
    }

    // Send Interest with Block Check and Membership Limit Check
    function sendInterest(event, toUserID) {
        event.stopPropagation();
        event.preventDefault();

        // Check remaining interests
        const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
        if (remainingInterests <= 0) {
            showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
            return;
        }

        // First check if user is blocked
        checkIfBlocked(toUserID, function (isBlocked) {
            if (isBlocked) {
                showNotification('You cannot send interest to a blocked user!', 'error');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = event.target.closest('.btn-interest') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: toUserID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = 'rgba(40, 167, 69, 0.8)';
                            button.disabled = true;

                            // Update remaining interests count
                            const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                            remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                            showNotification('Interest sent successfully!', 'success');
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = 'rgba(255, 193, 7, 0.8)';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else if (response.d === "blocked") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Cannot send interest to blocked user!', 'error');
                        } else if (response.d === "limit_reached") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        });
    }

    // Send Message with Block Check and Membership Limit Check
    function sendMessage(event, toUserID) {
        event.stopPropagation();
        event.preventDefault();

        // Check remaining messages
        const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
        if (remainingMessages <= 0) {
            showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
            return;
        }

        // First check if user is blocked
        checkIfBlocked(toUserID, function (isBlocked) {
            if (isBlocked) {
                showNotification('You cannot send message to a blocked user!', 'error');
                return;
            }

            const message = prompt('Enter your message:');
            if (message) {
                const button = event.target.closest('.btn-message') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: toUserID,
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = 'rgba(40, 167, 69, 0.8)';
                            button.disabled = true;

                            // Update remaining messages count
                            const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                            remainingElement.innerText = parseInt(remainingElement.innerText) - 1;

                            showNotification('Message sent successfully!', 'success');
                        } else if (response.d === "blocked") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Cannot send message to blocked user!', 'error');
                        } else if (response.d === "limit_reached") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            }
        });
    }

    // Check if user is blocked
    function checkIfBlocked(targetUserID, callback) {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/CheckIfBlocked",
            data: JSON.stringify({
                currentUserID: parseInt(currentUserID),
                targetUserID: targetUserID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                callback(response.d);
            },
            error: function () {
                callback(false);
            }
        });
    }

    // Shortlist Profile
    function shortlistProfile(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        const button = event.target.closest('.btn-shortlist') || event.target;
        const originalText = button.innerHTML;
        button.innerHTML = '⏳ Shortlisting...';
        button.disabled = true;

        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/ShortlistProfile",
            data: JSON.stringify({
                userID: parseInt(currentUserID),
                shortlistedUserID: userID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    button.innerHTML = '✅ Shortlisted';
                    button.style.background = 'rgba(40, 167, 69, 0.8)';
                    button.disabled = true;
                    showNotification('Profile shortlisted successfully!', 'success');
                } else if (response.d === "exists") {
                    button.innerHTML = '✅ Already Shortlisted';
                    button.style.background = 'rgba(255, 193, 7, 0.8)';
                    button.disabled = true;
                    showNotification('You have already shortlisted this profile!', 'info');
                } else {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            },
            error: function () {
                button.innerHTML = originalText;
                button.disabled = false;
                showNotification('Error shortlisting!', 'error');
            }
        });
    }

    // Block User Function
    function blockUser(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
            const button = event.target.closest('.btn-block') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Blocking...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/BlockUser",
                data: JSON.stringify({
                    blockedByUserID: parseInt(currentUserID),
                    blockedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Blocked';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('User blocked successfully!', 'success');
                        
                        // Remove the profile card from view
                        setTimeout(() => {
                            const profileCard = event.target.closest('.profile-card');
                            if (profileCard) {
                                profileCard.style.opacity = '0.5';
                                profileCard.style.pointerEvents = 'none';
                            }
                        }, 1000);
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Blocked';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('You have already blocked this user!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error blocking user!', 'error');
                }
            });
        }
    }

    // Report User Function
    function reportUser(event, userID) {
        event.stopPropagation();
        event.preventDefault();

        const reportReason = prompt('Please specify the reason for reporting this profile:');
        if (reportReason) {
            const button = event.target.closest('.btn-report') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Reporting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ReportUser",
                data: JSON.stringify({
                    reportedByUserID: parseInt(currentUserID),
                    reportedUserID: userID,
                    reportReason: reportReason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Reported';
                        button.style.background = 'rgba(108, 117, 125, 0.8)';
                        button.disabled = true;
                        showNotification('User reported successfully! Our team will review this profile.', 'success');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error reporting user!', 'error');
                }
            });
        }
    }

    // Notification Functions
    function initializeNotifications() {
        loadNotifications();
        setInterval(loadNotifications, 30000); // Refresh every 30 seconds
        
        // Notification bell click event
        $('#btnNotificationBell').click(function(e) {
            e.stopPropagation();
            $('#notificationDropdown').toggle();
        });
        
        // Mark all as read
        $('#btnMarkAllRead').click(function() {
            markAllNotificationsAsRead();
        });
        
        // Close dropdown when clicking outside
        $(document).click(function() {
            $('#notificationDropdown').hide();
        });
    }

    function loadNotifications() {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
        
        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/GetNotifications",
            data: JSON.stringify({
                userID: parseInt(currentUserID)
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d) {
                    const data = JSON.parse(response.d);
                    updateNotificationUI(data);
                }
            },
            error: function () {
                console.log('Error loading notifications');
            }
        });
    }

    function updateNotificationUI(data) {
        // Update badge counts
        if (data.TotalUnread > 0) {
            $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
        } else {
            $('#<%= totalNotificationBadge.ClientID %>').hide();
        }
        
        if (data.UnreadInterests > 0) {
            $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
        } else {
            $('#<%= interestNotification.ClientID %>').hide();
        }
        
        if (data.UnreadMessages > 0) {
            $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
        } else {
            $('#<%= messageNotification.ClientID %>').hide();
        }
        
        // Update notification list
        const notificationList = $('#notificationList');
        notificationList.empty();
        
        if (data.Notifications.length === 0) {
            notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
        } else {
            data.Notifications.forEach(notification => {
                const notificationItem = $(`
                    <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                        <div class="notification-content">${notification.Message}</div>
                        <div class="notification-time">${notification.TimeAgo}</div>
                    </div>
                `);
                
                notificationItem.click(function() {
                    markNotificationAsRead(notification.NotificationID);
                    handleNotificationClick(notification);
                });
                
                notificationList.append(notificationItem);
            });
        }
    }

    function markNotificationAsRead(notificationID) {
        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/MarkNotificationAsRead",
            data: JSON.stringify({
                notificationID: notificationID
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    // Remove the unread style
                    $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                    loadNotifications(); // Refresh counts
                }
            }
        });
    }

    function markAllNotificationsAsRead() {
        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

        $.ajax({
            type: "POST",
            url: "Dashboard.aspx/MarkAllNotificationsAsRead",
            data: JSON.stringify({
                userID: parseInt(currentUserID)
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    loadNotifications();
                    showNotification('All notifications marked as read!', 'success');
                }
            }
        });
    }

    function handleNotificationClick(notification) {
        // Handle navigation based on notification type
        switch (notification.Type) {
            case 'Interest':
                window.location.href = 'Interests.aspx';
                break;
            case 'Message':
                window.location.href = 'Messages.aspx';
                break;
            case 'Shortlist':
                window.location.href = 'Shortlisted.aspx';
                break;
            case 'ProfileView':
                window.location.href = 'TotalViews.aspx';
                break;
            default:
                // Do nothing
                break;
        }

        // Close dropdown
        $('#notificationDropdown').hide();
    }

    // Notification function
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.padding = '15px 20px';
        notification.style.borderRadius = '10px';
        notification.style.color = 'white';
        notification.style.fontWeight = 'bold';
        notification.style.zIndex = '10000';
        notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
        notification.style.backdropFilter = 'blur(10px)';
        notification.style.border = '1px solid rgba(255,255,255,0.2)';

        if (type === 'success') {
            notification.style.background = 'rgba(40, 167, 69, 0.8)';
        } else if (type === 'error') {
            notification.style.background = 'rgba(220, 53, 69, 0.8)';
        } else if (type === 'info') {
            notification.style.background = 'rgba(23, 162, 184, 0.8)';
        }

        notification.innerHTML = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 3000);
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', function () {
        initializeNotifications();
        initializeClickableSections();
        console.log('Dashboard loaded successfully');
    });
</script>
</asp:Content>







--%>
