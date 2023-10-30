from locust import HttpUser, task, between

authToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyRW1haWwiOiJibGFjazRyb2FjaEBnbWFpbC5jb20iLCJpYXQiOjE2OTc2NzY3MTUsImV4cCI6MTY5ODg3NjcxNX0.II9z0NwqLHuFA4CJsr3wpBJuuCfJRBskZmQsrW_WSoc"

class HelloWorldUser(HttpUser):
    wait_time = between(1, 2.5)
    headers = {
        "Authorization": authToken
    }
    # @task
    # def hello_world(self):
    #     self.client.get("/health")

    @task(500)
    def get_workflows(self):
        headers = {
            "Authorization": authToken
        }
        self.client.get("/workspaces/43/workflows", headers=headers)
    @task(500)
    def get_workflow(self):
        headers = {
            "Authorization": authToken
        }
        self.client.get("/workspaces/43/workflows/136", headers=headers)

    # @task(10)
    # def get_member(self):
    #     headers = {
    #         "Authorization": authToken
    #     }
    #     self.client.get("/workspaces/43/members?type=employee", headers=headers)

    # @task(10)
    # def get_dashboards(self):
    #     headers = {
    #         "Authorization": authToken
    #     }
    #     self.client.get("/workspaces/43/dashboard/workflows", headers=headers)

    # @task(10)
    # def get_dashboard(self):
    #     headers = {
    #         "Authorization": authToken
    #     }
    #     self.client.get("/workspaces/43/dashboard/workflows/136/members", headers=headers)

    @task(1)
    def create_member(self):
        headers = {
            "Authorization": authToken
        }
        member_body = {
            "wid": 43,
            "name": "부하에용",
            "email": "distribute@workplug.team",
            "phoneNum": "010-4055-6477",
            "startDate": "2023-09-27",
            "department": "rideat",
            "type": "employee"
        }

        self.client.post("/workspaces/43/members", json=member_body, headers=headers)


    # @task(1)
    # def launch_workflow(self):
    #     headers = {
    #         "Authorization": authToken
    #     }
    #     launch_body = [
    #         {
    #         "memberId": 35,
    #         "keyDate": "2023-09-27",
    #         "members": [
    #           {
    #             "memberId": 692,
    #             "roleId": 133
    #           },{
    #             "memberId": 693,
    #             "roleId": 134
    #           },{
    #             "memberId": 693,
    #             "roleId": 135
    #           }
    #         ]
    #         }
    #     ]
    #     self.client.post("/workspaces/43/workflows/136/launch", json=launch_body, headers=headers)
    
    # @task(1)
    # def check_noti(self):
    #     headers = {
    #         "Authorization": authToken
    #     }
    #     self.client.get("/workspaces/43/notifications", headers=headers)
