#!/usr/bin/env python3
"""
Data Renderer for Job Dashboard
This script generates sample job data and renders it to the HTML file.
Perfect for testing CI/CD pipelines.
"""

import json
import random
from datetime import datetime, timedelta
import re

def generate_sample_jobs():
    """Generate sample job data for demonstration"""
    
    companies = [
        "TechCorp", "InnovateSoft", "DataFlow", "CloudTech", "DevWorks",
        "CodeCraft", "ByteLogic", "FutureSystems", "SmartSolutions", "DigitalDynamics"
    ]
    
    job_titles = [
        "Software Engineer", "Data Scientist", "DevOps Engineer", "Frontend Developer",
        "Backend Developer", "Full Stack Developer", "Machine Learning Engineer",
        "Product Manager", "UX Designer", "QA Engineer", "System Administrator",
        "Cloud Architect", "Security Engineer", "Mobile Developer", "Data Engineer"
    ]
    
    locations = [
        "New York, NY", "San Francisco, CA", "Austin, TX", "Seattle, WA",
        "Boston, MA", "Denver, CO", "Chicago, IL", "Los Angeles, CA",
        "Remote", "Washington, DC", "Atlanta, GA", "Portland, OR"
    ]
    
    jobs = []
    
    for i in range(25):  # Generate 25 sample jobs
        is_remote = random.choice([True, False])
        location = "Remote" if is_remote else random.choice(locations)
        
        # Ensure some jobs are US-based
        if not is_remote and random.random() < 0.8:
            location = random.choice([loc for loc in locations if loc != "Remote"])
        
        job = {
            "id": i + 1,
            "title": random.choice(job_titles),
            "company": random.choice(companies),
            "location": location,
            "salary_range": f"${random.randint(80, 200)}k - ${random.randint(200, 350)}k",
            "posted_date": (datetime.now() - timedelta(days=random.randint(0, 30))).strftime("%Y-%m-%d"),
            "is_remote": is_remote,
            "is_us_based": location != "Remote" and any(state in location for state in ["NY", "CA", "TX", "WA", "MA", "CO", "IL", "DC", "GA", "OR"])
        }
        jobs.append(job)
    
    return jobs

def render_html_with_data(jobs_data):
    """Render the HTML file with the provided job data"""
    
    # Calculate statistics
    total_jobs = len(jobs_data)
    us_jobs = sum(1 for job in jobs_data if job["is_us_based"])
    remote_jobs = sum(1 for job in jobs_data if job["is_remote"])
    
    # Read the HTML template
    with open('index.html', 'r', encoding='utf-8') as file:
        html_content = file.read()
    
    # Generate jobs HTML
    jobs_html = ""
    for job in jobs_data[:10]:  # Show only first 10 jobs
        location_class = "remote" if job["is_remote"] else "onsite"
        jobs_html += f'''
        <div class="job-item {location_class}">
            <div class="job-title">{job["title"]}</div>
            <div class="job-company">{job["company"]}</div>
            <div class="job-location">{job["location"]} • {job["salary_range"]}</div>
        </div>
        '''
    
    # Update statistics in HTML
    html_content = re.sub(r'id="total-jobs">0<', f'id="total-jobs">{total_jobs}<', html_content)
    html_content = re.sub(r'id="us-jobs">0<', f'id="us-jobs">{us_jobs}<', html_content)
    html_content = re.sub(r'id="remote-jobs">0<', f'id="remote-jobs">{remote_jobs}<', html_content)
    html_content = re.sub(r'id="last-updated">0<', f'id="last-updated">{total_jobs}<', html_content)
    
    # Update jobs container
    html_content = re.sub(
        r'<div id="jobs-container">.*?</div>',
        f'<div id="jobs-container">{jobs_html}</div>',
        html_content,
        flags=re.DOTALL
    )
    
    # Update timestamp
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    html_content = re.sub(
        r'<span id="update-time">Never</span>',
        f'<span id="update-time">{current_time}</span>',
        html_content
    )
    
    # Write the updated HTML
    with open('index.html', 'w', encoding='utf-8') as file:
        file.write(html_content)
    
    print(f"✅ HTML file updated successfully!")
    print(f"📊 Total jobs: {total_jobs}")
    print(f"🇺🇸 US jobs: {us_jobs}")
    print(f"🏠 Remote jobs: {remote_jobs}")
    print(f"🕒 Last updated: {current_time}")

def main():
    """Main function to run the data renderer"""
    print("🚀 Starting job data renderer...")
    
    try:
        # Generate sample job data
        jobs = generate_sample_jobs()
        
        # Render data to HTML
        render_html_with_data(jobs)
        
        print("🎉 Data rendering completed successfully!")
        print("📁 Check index.html for the updated dashboard")
        
    except Exception as e:
        print(f"❌ Error occurred: {str(e)}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
