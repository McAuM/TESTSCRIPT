#include <axutil_array_list.h>
#include <axis2_svc_skeleton.h>
#include <axutil_log_default.h>
#include <axutil_error_default.h>
#include <axiom_text.h>
#include <axiom_node.h>
#include <axiom_element.h>
#include <axis2_const.h>
#include <axis2_op_ctx.h>
#include <axiom.h>
#include <axiom_soap_envelope.h>
#include <axiom_soap_body.h>
#include <axutil_param.h>
#include <stdio.h>
//#include <stdlib.h>
#include <mysql.h>
#include "sha1.h"

axiom_node_t *axis2_download(
    const axutil_env_t * env,
    axiom_node_t * node);
axiom_node_t *axis2_recover(
    const axutil_env_t * env,
    axiom_node_t * node);

int cut(char *string);
int sharecheck(axis2_char_t *param1_str, axis2_char_t *param2_str, char *dest);
int authen(char *param1_str);
/*axiom_node_t *axis2_calc_mul(
 *     const axutil_env_t * env,
 *         axiom_node_t * node);
 *         axiom_node_t *axis2_calc_div(
 *             const axutil_env_t * env,
 *                 axiom_node_t * node);*/

int AXIS2_CALL sync_free(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env);

/*
 *  * This method invokes the right service method
 *   */
axiom_node_t *AXIS2_CALL sync_invoke(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env,
    axiom_node_t * node,
    axis2_msg_ctx_t * msg_ctx);

int AXIS2_CALL sync_init(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env);

static const axis2_svc_skeleton_ops_t sync_svc_skeleton_ops_var = {
    sync_init,
    sync_invoke,
    NULL,
    sync_free
};

AXIS2_EXTERN axis2_svc_skeleton_t *AXIS2_CALL
axis2_sync_create(
    const axutil_env_t * env)
{
    axis2_svc_skeleton_t *svc_skeleton = NULL;
    svc_skeleton = AXIS2_MALLOC(env->allocator, sizeof(axis2_svc_skeleton_t));

    svc_skeleton->ops = &sync_svc_skeleton_ops_var;

    svc_skeleton->func_array = NULL;

    return svc_skeleton;
}

int AXIS2_CALL
sync_init(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env)
{
    /* Any initialization stuff of calc goes here */
    return AXIS2_SUCCESS;
}

int AXIS2_CALL
sync_free(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env)
{
    if (svc_skeleton)
    {
        AXIS2_FREE(env->allocator, svc_skeleton);
        svc_skeleton = NULL;
    }
    return AXIS2_SUCCESS;
}

/*
 *  * This method invokes the right service method
 *   */
axiom_node_t *AXIS2_CALL
sync_invoke(
    axis2_svc_skeleton_t * svc_skeleton,
    const axutil_env_t * env,
    axiom_node_t * node,
    axis2_msg_ctx_t * msg_ctx)
{
    /* Depending on the function name invoke the
 *      *  corresponding calc method
 *           */
    if (node)
    {
        if (axiom_node_get_node_type(node, env) == AXIOM_ELEMENT)
        {
            axiom_element_t *element = NULL;
            element =
                (axiom_element_t *) axiom_node_get_data_element(node, env);
            if (element)
            {
                axis2_char_t *op_name =
                    axiom_element_get_localname(element, env);
                if (op_name)
                {
                    if (axutil_strcmp(op_name, "download") == 0)
                        return axis2_download(env, node);
                    if (axutil_strcmp(op_name, "recover") == 0)
                        return axis2_recover(env, node);
             
                }
            }
        }
    }

    printf("Cloud service ERROR: invalid OM parameters in request\n");

    /** Note: return a SOAP fault here */
    return node;
}

/**
 *  * Following block distinguish the exposed part of the dll.
 *   */

AXIS2_EXPORT int
axis2_get_instance(
    struct axis2_svc_skeleton **inst,
    const axutil_env_t * env)
{
    *inst = axis2_sync_create(env);
    if (!(*inst))
    {
        return AXIS2_FAILURE;
    }

    return AXIS2_SUCCESS;
}

AXIS2_EXPORT int
axis2_remove_instance(
    axis2_svc_skeleton_t * inst,
    const axutil_env_t * env)
{
    axis2_status_t status = AXIS2_FAILURE;
    if (inst)
    {
        status = AXIS2_SVC_SKELETON_FREE(inst, env);
    }
    return status;
}
/* permission */

int cut(char *string)
{
  int x=0;
  int len = strlen(string);
  for(x=0;x<len;x++)
  {
    if (string[x]=='/')
    {
	return x;
    }
  }
  return -1;
}

int sharecheck(axis2_char_t *param1_str, axis2_char_t *param2_str, char *dest)
{
  MYSQL *conn;
  MYSQL_RES *res;
  MYSQL_ROW row;
  char *server = "localhost";	
  char *user = "cloud";
  char *password = "vbmTbgvdik=1234";
  char *database = "cloud"; 
  conn = mysql_init(NULL);
  if (!mysql_real_connect(conn, server, user, password, database, 0 ,NULL, 0))
  {
	printf("Error %u: %s\n",mysql_errno(conn),mysql_error(conn));	
     	return 1;
  }
  char query[1000];
  /*sprintf(query,"SELECT * FROM shared, groupmember WHERE shared.GroupNo = groupmember.GroupNo AND shared.Username =  '%s' AND groupmember.Username = '%s'", dest,param1_str); */
  sprintf(query,"SELECT * FROM shared, groupmember, sharedgroup WHERE shared.SharedNo = sharedgroup.SharedNo AND sharedgroup.GroupNo = groupmember.GroupNo AND shared.Username =  '%s' AND groupmember.Username = '%s' AND shared.flags = '1' AND (shared.Since <= now() AND (shared.To >= now() OR shared.To = 0))", dest,param1_str);
  mysql_query(conn,query);
  res = mysql_use_result(conn);
 
  while ((row = mysql_fetch_row(res)) != NULL )
  {
	char *cmp = strstr(param2_str, row[2]);
	if (cmp != NULL)
	{
	   if (strcmp(cmp, param2_str)==0)
	   {
  		  mysql_free_result(res);
  		  mysql_close(conn);
		  return 0;			
	   }	
	}
  }
  mysql_free_result(res);
  mysql_close(conn);
  return -1;
}


int authen(char *param1_str)
{
  char *key = "hjK$12";
  char *pch;
  pch = strtok (param1_str,":");
  if (pch == NULL)
	return -1;
  char *username = pch;
  pch = strtok (NULL, ":");
  if (pch == NULL)
	return -1;
  char *sha1_str = pch;
  char token[50];
  sprintf(token,"%s%s", username, key);
  if (strcmp(sha1(token),sha1_str)==0)
  {
	  strcpy(param1_str, username);
	  return 0;
  }

  return -1;
}

/* action below */

axiom_node_t *
axis2_download(
    const axutil_env_t * env,
    axiom_node_t * node)
{
    axiom_node_t *complex_node = NULL;
    axiom_node_t *seq_node = NULL;
    axiom_node_t *param1_node = NULL;
    axiom_node_t *param1_text_node = NULL;
    axis2_char_t *param1_str = NULL;
    axiom_node_t *param2_node = NULL;
    axiom_node_t *param2_text_node = NULL;
    axis2_char_t *param2_str = NULL;
	axiom_node_t *param3_node = NULL;
    axiom_node_t *param3_text_node = NULL;
    axis2_char_t *param3_str = NULL;

    if (!node)
    {
        AXIS2_ERROR_SET(env->error, AXIS2_ERROR_SVC_SKEL_INPUT_OM_NODE_NULL,
                        AXIS2_FAILURE);
        printf("Make Folder request ERROR: input parameter NULL\n");
        return NULL;
    }

	printf("\nservice : sync\n");
	printf("operation : download\n");	
    complex_node = axiom_node_get_first_child(node, env);
    if (!complex_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder Param1 Node  ERROR: invalid XML in request\n");
        return NULL;
    }

	// USERNAME

    param1_text_node = axiom_node_get_first_child(complex_node, env);
    if (!param1_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder Param1 Text  ERROR: invalid XML in request\n");
        return NULL;
    }

    if (axiom_node_get_node_type(param1_text_node,env)== AXIOM_TEXT)
    {

	axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param1_text_node, env);
   	if (text && axiom_text_get_value(text, env))
       	{
         	param1_str = (axis2_char_t *) axiom_text_get_value(text, env);
		if (authen(param1_str))
			return NULL;
		printf("param1 (username) : %s\n",param1_str);
       	}
     }
     else
     {
	AXIS2_ERROR_SET(env->error, AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,AXIS2_FAILURE);
	printf("Make Folder Type Mismatch\n");
	return NULL;
     }

	// PATH

    param2_node = axiom_node_get_next_sibling(complex_node, env);
	
    if (!param2_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder ERROR: invalid XML in request\n");
        return NULL;
    }
    param2_text_node = axiom_node_get_first_child(param2_node, env);
	
    if (!param2_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder  ERROR: invalid XML in request\n");
        return NULL;
    }
	
    if (axiom_node_get_node_type(param2_text_node, env) == AXIOM_TEXT)
    {
        axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param2_text_node, env);
        if (text && axiom_text_get_value(text, env))
        {
            param2_str = (axis2_char_t *) axiom_text_get_value(text, env);
			printf("param2 (path) : %s\n",param2_str);
        }
    }
    else
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("AXIOM TEXT ERROR: invalid XML in request\n");
        return NULL;
    }

	// FILE NAME

	param3_node = axiom_node_get_next_sibling(param2_node, env);
	
    if (!param3_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder ERROR: invalid XML in request\n");
        return NULL;
    }
    param3_text_node = axiom_node_get_first_child(param3_node, env);
	
    if (!param3_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder  ERROR: invalid XML in request\n");
        return NULL;
    }
	
    if (axiom_node_get_node_type(param3_text_node, env) == AXIOM_TEXT)
    {
        axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param3_text_node, env);
        if (text && axiom_text_get_value(text, env))
        {
            param3_str = (axis2_char_t *) axiom_text_get_value(text, env);
			printf("param3 (filename) : %s\n",param3_str);
        }
    }
    else
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("AXIOM TEXT ERROR: invalid XML in request\n");
        return NULL;
    }


    if (param1_str && param2_str)
    {
        int result = 0;
		axis2_char_t command[2000];

        axiom_element_t *ele1 = NULL;
		axiom_element_t *ele2 = NULL;
        axiom_node_t *node1 = NULL,
        *node2 = NULL, *node3 = NULL;

        axiom_namespace_t *ns1 = NULL;
        axiom_text_t *text1 = NULL; 
		
		int check=0;
        ns1 = axiom_namespace_create(env,
                                     "http://10.35.30.172:9090/axis2/services/sync/types", "ns1");
        ele1 = axiom_element_create(env, NULL, "result", NULL, &node1);
		ele2 = axiom_element_create(env, NULL, "downloadResponse", ns1, &node2);
		axiom_node_add_child(node2, env, node1);
		char *dest = strndup(param2_str, cut(param2_str));
       
		char *sha1_str = NULL;
		char str[1000];
		char return_str[200];

		char temp_php[500];
		char filename[200];
		FILE *fp;
    
    //tpi1
    char buffstr[255];
    char str2[255];
    int len_tpi;
    FILE *fp_tpi,*ptr_tmp;
    char token_tpi1[255]="/home/hadoop/test/token.pcs1";
    char token_tpi2[255]="/home/hadoop/test/token.pcs2";
    char token_tpi3[255]="/home/hadoop/test/token.pcs3";
    char dbi1[255]="/home/hadoop/test/dbiV4sk.jar";
    char path_incloud_a[255]="/home/hadoop/test/in_cloud.txt";
    char path_incloud1[255]="/home/hadoop/test/in_cloud1.txt";
    char path_incloud2[255]="/home/hadoop/test/in_cloud2.txt";
    char path_incloud3[255]="/home/hadoop/test/in_cloud3.txt";
    char path_temp[255]="/home/hadoop/test/temp.txt";
    char path_loadback[255]="/home/hadoop/test/loadback";
    char filename_tpi[255];
    char path_conf[255]="/home/hadoop/test/conf_tpi.txt";
    int flag_onoff=0;
		/*
		if(param2_str[strlen(param2_str) - 1] != '/')
		{
			param2_start[strlen(param2_str)] = '/');
			param2_start[strlen(param2_str) + 1] = '\0');
		}
		*/
    //tpi2
    char path_conf_All[255]="/home/hadoop/TESAPI/TESTSCRIPT/set_Auto.txt";
    char path_incloud_all[255]="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud_All.txt";
    char path_cmd_NAS[255]="/home/hadoop/TESAPI/TESTSCRIPT/nasapi.sh";
    char path_in_NAS[255]="/home/hadoop/TESAPI/TESTSCRIPT/in_NAS1.txt";
    char path_tempfile[255]="/home/hadoop/TESAPI/TESTSCRIPT/tempfile/";
    char path_temptext[255]="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt";
    char path_temptext2[255]="/home/hadoop/TESAPI/TESTSCRIPT/temp2.txt";
		if (strcmp(dest,param1_str)==0) /* if you are an owner of a file*/
		{	
			/*CODING HERE*/
      // sprintf(command,"echo 'Yes' > /home/hadoop/TESAPI/TESTSCRIPT/z.txt");
      // system(command);

			if(param2_str[strlen(param2_str) - 1] != '/')
				sprintf(str, "%s/%s", param2_str, param3_str);
			else
				sprintf(str, "%s%s", param2_str, param3_str);

      //tpi1
      strcpy(filename_tpi,param3_str);
      //printf("filename is %s\n", filename_tpi );
      //printf("str is %s\n", str );

	  // onoff
	  flag_onoff=0;
	  fp_tpi = fopen(path_conf_All, "r");
	  if( fp_tpi != NULL ){
		  while ( !feof(fp_tpi ) ){
	      	memset(buffstr, '\0', sizeof( buffstr) );
	        fgets(buffstr, 255, (FILE*)fp_tpi);
	        strcpy(str2, buffstr);
	  	    if(str2[0]=='1'){
	  	      flag_onoff=1;
	  	    }
	      }
	  }
	  fclose(fp_tpi);
    //printf("Flag on-off is %d\n", flag_onoff );
	  //add multi cloud
	  //start check in cloud
	  if(flag_onoff==1){
	     fp_tpi = fopen(path_incloud1, "r");
	     if( fp_tpi != NULL ){
	      while ( !feof(fp_tpi ) ){
	         memset(buffstr, '\0', sizeof( buffstr) );
	         fgets(buffstr, 255, (FILE*)fp_tpi);
	         //printf("%s", buffstr );
	         strcpy(str2, buffstr);
	         //sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
	        len_tpi = strlen(str2);
	        if( str2[len_tpi-1] == '\n' || str2[len_tpi-1] == '\r' ){
	            str2[len_tpi-1] = '\0';
	        }else{
	        }
	        if(strcmp(str,str2)==0){
	            sprintf(command,"java -jar %s download %s %s/%s /%s",dbi1,token_tpi1,path_loadback,filename_tpi,str2);
	            system(command);
	            sprintf(command,"hadoop dfs -moveFromLocal %s/%s %s",path_loadback,filename_tpi,str2);
	            system(command);
	            // delete in_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud1,path_temp,path_temp,path_incloud1);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud1,path_temp,path_temp,path_incloud1);
	            system(command);
	            // delete big_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);

	        }else{
	            //sprintf(command,"echo 'else' >>/home/hadoop/test/z.txt");
	            //system(command);
	        }
	         
	      }
	  	}
	  		fclose(fp_tpi);
	  		//// end 1

	  		fp_tpi = fopen(path_incloud2, "r");
	     if( fp_tpi != NULL ){
	      while ( !feof(fp_tpi ) ){
	         memset(buffstr, '\0', sizeof( buffstr) );
	         fgets(buffstr, 255, (FILE*)fp_tpi);
	         //printf("%s", buffstr );
	         strcpy(str2, buffstr);
	         //sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
	        len_tpi = strlen(str2);
	        if( str2[len_tpi-1] == '\n' || str2[len_tpi-1] == '\r' ){
	            str2[len_tpi-1] = '\0';
	        }else{
	        }
	        if(strcmp(str,str2)==0){
	            sprintf(command,"java -jar %s download %s %s/%s /%s",dbi1,token_tpi2,path_loadback,filename_tpi,str2);
	            system(command);
	            sprintf(command,"hadoop dfs -moveFromLocal %s/%s %s",path_loadback,filename_tpi,str2);
	            system(command);
	            // delete in_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud2,path_temp,path_temp,path_incloud2);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud2,path_temp,path_temp,path_incloud2);
	            system(command);
	            // delete big_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);

	        }else{
	            //sprintf(command,"echo 'else' >>/home/hadoop/test/z.txt");
	            //system(command);
	        }
	         
	      }
	  	}
	  		fclose(fp_tpi);
	  		// end 2

	  	 fp_tpi = fopen(path_incloud3, "r");
	     if( fp_tpi != NULL ){
	      while ( !feof(fp_tpi ) ){
	         memset(buffstr, '\0', sizeof( buffstr) );
	         fgets(buffstr, 255, (FILE*)fp_tpi);
	         //printf("%s", buffstr );
	         strcpy(str2, buffstr);
	         //sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
	        len_tpi = strlen(str2);
	        if( str2[len_tpi-1] == '\n' || str2[len_tpi-1] == '\r' ){
	            str2[len_tpi-1] = '\0';
	        }else{
	        }
	        if(strcmp(str,str2)==0){
	            sprintf(command,"java -jar %s download %s %s/%s /%s",dbi1,token_tpi3,path_loadback,filename_tpi,str2);
	            system(command);
	            sprintf(command,"hadoop dfs -moveFromLocal %s/%s %s",path_loadback,filename_tpi,str2);
	            system(command);
	            // delete in_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud3,path_temp,path_temp,path_incloud3);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud3,path_temp,path_temp,path_incloud3);
	            system(command);
	            // delete big_cloud
	            sprintf(command,"sed 's-%s--g' %s > %s && mv %s %s",str2,path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);
	            sprintf(command,"sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud_a,path_temp,path_temp,path_incloud_a);
	            system(command);

	        }else{
	            //sprintf(command,"echo 'else' >>/home/hadoop/test/z.txt");
	            //system(command);
	        }
	         
	      }
	  	}
	  	fclose(fp_tpi);
	  	//end3

      fp_tpi = fopen(path_in_NAS, "r");
      if( fp_tpi != NULL ){
        while ( !feof(fp_tpi ) ){
           memset(buffstr, '\0', sizeof( buffstr) );
           fgets(buffstr, 255, (FILE*)fp_tpi);
           //printf("%s", buffstr );
           strcpy(str2, buffstr);
           //sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
          len_tpi = strlen(str2);
          if( str2[len_tpi-1] == '\n' || str2[len_tpi-1] == '\r' ){
              str2[len_tpi-1] = '\0';
          }else{
          }
          //printf("str2 is %s\n", str2 );         
          // split space bar and keep in variable            
          char *tmpstr2, *saveptr, *tmpID;
          char *tmprest = str2;                    
          tmpstr2 = strtok_r(tmprest, " ", &saveptr);
          tmpID = strtok_r(NULL, " ", &saveptr);
          if (tmpstr2==NULL){
            tmpstr2="";
          }      
          //printf("tmpstr2 is %s\n", tmpstr2 );
          //printf("tmpID is %s\n", tmpID );    
          if(strcmp(str,tmpstr2)==0){             
             //printf("Yes\n");                          
             sprintf(command,"sh %s download 1 %s %s%s",path_cmd_NAS,tmpID,path_tempfile,filename_tpi);
             system(command);
             sprintf(command,"sh %s delete 1 %s ",path_cmd_NAS,tmpID);
             system(command);
             sprintf(command,"hadoop dfs -moveFromLocal %s%s %s",path_tempfile,filename_tpi,str2);           
             system(command);
             
            // delete in_cloud                                              
              sprintf(command,"grep -v %s %s > %s",str2,path_in_NAS,path_temptext2);
              system(command);
              ptr_tmp = fopen(path_temptext2, "r");
              if( ptr_tmp != NULL ){
              memset(buffstr, '\0', sizeof( buffstr) );
              fgets(buffstr, 255, (FILE*)ptr_tmp);
              printf("buffstr %s\n",buffstr);       
              if ( strcmp(buffstr,"")!=0 ){
                sprintf(command,"grep -v %s %s > %s && mv %s %s",str2,path_in_NAS,path_temptext,path_temptext,path_in_NAS);                 
                system(command);
              }
              else{
                sprintf(command,"echo \"\" > %s && sed '/^\\s*$/d' %s > %s && mv %s %s",path_in_NAS,path_in_NAS,path_temptext,path_temptext,path_in_NAS);
                system(command);
              }                
            }
            fclose(ptr_tmp);
            
            // delete big_cloud
              sprintf(command,"grep -v %s %s > %s",str2,path_incloud_all,path_temptext2);
              system(command);
              ptr_tmp = fopen(path_temptext2, "r");
              if( ptr_tmp != NULL ){
              memset(buffstr, '\0', sizeof( buffstr) );
              fgets(buffstr, 255, (FILE*)ptr_tmp);
              printf("buffstr %s\n",buffstr);       
              if ( strcmp(buffstr,"")!=0 ){
                sprintf(command,"grep -v %s %s > %s && mv %s %s",str2,path_incloud_all,path_temptext,path_temptext,path_incloud_all);                 
                system(command);
              }
              else{
                sprintf(command,"echo \"\" > %s && sed '/^\\s*$/d' %s > %s && mv %s %s",path_incloud_all,path_incloud_all,path_temptext,path_temptext,path_incloud_all);
                system(command);
              }                
            }
            fclose(ptr_tmp);
            break;
           }else{
             //printf("No file\n");    
           }
           
        }        
      }      
      fclose(fp_tpi);      
      //end4
   }
   		sha1_str = sha1(str);
      
			
			sprintf(command, "rm -rf /var/www/html/get/%s", sha1_str);
			system(command);

			sprintf(command, "mkdir /var/www/html/get/%s", sha1_str);
			system(command);


			sprintf(command, "hadoop dfs -get \"/user/hadoop/%s/%s\" \"/var/www/html/get/%s/%s\"", param2_str, param3_str, sha1_str, param3_str);
			system(command);

			sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
			if (!system(command))
			{
				
				/*sprintf(command, "zip -r \"/var/www/html/get/%s/%s\" \"/var/www/html/get/%s/%s\"", sha1_str,param3_str, sha1_str, param3_str);
				system(command);*/
				sprintf(command, "cd \"/var/www/html/get/%s\" && zip -r \"%s\" \"%s\" && cd ../../../../../", sha1_str, param3_str, param3_str);
				system(command);
				sprintf(command, "rm -rf \"/var/www/html/get/%s/%s\"", sha1_str, param3_str);
				system(command);
				

			/*sprintf(temp_php, "<?php\nheader(\"Location:%s\");\n?>", param3_str);*/
		
				sprintf(temp_php,"<?php\n$file = (\"%s.zip\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
				sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);
				fp = fopen(filename, "w+");
				fprintf(fp, "%s", temp_php);
				fclose(fp);
			}
			else
			{
				sprintf(temp_php,"<?php\n$file = (\"%s\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
				sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);
				fp = fopen(filename, "w+");
				fprintf(fp, "%s", temp_php);
				fclose(fp);
			}

			/*sprintf(temp_php,"DirectoryIndex %s.php", sha1_str);*/
			sprintf(temp_php,"DirectoryIndex %s.php\nRewriteEngine On\nRewriteCond %%{REQUEST_FILENAME} -f [OR]\nRewriteCond %%{REQUEST_FILENAME} -d\nRewriteRule ^(.+) - [PT,L]\n\nRewriteRule ^(.*) %s.php", sha1_str,sha1_str);
			sprintf(filename, "/var/www/html/get/%s/.htaccess", sha1_str);
			fp = fopen(filename,"w+");
			fprintf(fp, "%s", temp_php);
			fclose(fp);
			
		}
		else /* if you request a link from other's person file*/
		{
			check = sharecheck(param1_str, param2_str, dest); /* checking shareing access control*/ 
			if (check==0)
			{
				/* CODING HERE (nearly the same as above)*/

				if(param2_str[strlen(param2_str) - 1] != '/')
					sprintf(str, "%s/%s", param2_str, param3_str);
				else
					sprintf(str, "%s%s", param2_str, param3_str);

				sha1_str = sha1(str);

				//tpi1
				sprintf(command,"echo 'in512' >>/home/hadoop/test/z.txt");
			 	system(command);

				sprintf(command, "rm -rf /var/www/html/get/%s", sha1_str);
				system(command);

				sprintf(command, "mkdir /var/www/html/get/%s", sha1_str);
				system(command);

				sprintf(command, "hadoop dfs -get \"/user/hadoop/%s/%s\" \"/var/www/html/get/%s/%s\"", param2_str, param3_str, sha1_str, param3_str);
				system(command);

				/*sprintf(temp_php, "<?php\nheader(\"Location:%s\");\n?>", param3_str);*/
				sprintf(command, "hadoop dfs -test -d \"/user/hadoop/%s/%s\"", param2_str, param3_str);
                        	if (!system(command))
	                        {
	
					sprintf(command, "cd \"/var/www/html/get/%s\" && zip -r \"%s\" \"%s\" && cd ../../../../../", sha1_str, param3_str, param3_str);
        	                        /*sprintf(command, "zip -r \"/var/www/html/get/%s/%s\" \"/var/www/html/get/%s/%s\"", sha1_str,param3_str, sha1_str, param3_str);*/
                	                system(command);
                        	        sprintf(command, "rm -rf \"/var/www/html/get/%s/%s\"", sha1_str, param3_str);
                                	system(command);

	                                sprintf(temp_php,"<?php\n$file = (\"%s.zip\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
        	                        sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);
                	                fp = fopen(filename, "w+");
                        	        fprintf(fp, "%s", temp_php);
                                	fclose(fp);
	                        }
        	                else
                	        {
                        	        sprintf(temp_php,"<?php\n$file = (\"%s\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
                                	sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);
	                                fp = fopen(filename, "w+");
        	                        fprintf(fp, "%s", temp_php);
                	                fclose(fp);
                        	}

				/*sprintf(temp_php,"DirectoryIndex %s.php", sha1_str);*/
				sprintf(temp_php,"DirectoryIndex %s.php\nRewriteEngine On\nRewriteCond %%{REQUEST_FILENAME} -f [OR]\nRewriteCond %%{REQUEST_FILENAME} -d\nRewriteRule ^(.+) - [PT,L]\n\nRewriteRule ^(.*) %s.php", sha1_str,sha1_str);
				sprintf(filename, "/var/www/html/get/%s/.htaccess", sha1_str);
				fp = fopen(filename,"w+");
				fprintf(fp, "%s", temp_php);
				fclose(fp);
			}
			else if (check == 1)
			{
				/* Database Error*/
        		text1 = axiom_text_create(env, node1, "Error:50", &node3);
				printf("result : Error\n");
        		return node2;
			}
			else if (check == -1)
			{
        		text1 = axiom_text_create(env, node1, "Error:1210", &node3); /*path haven't been shared*/
				printf("result : Error\n");
        		return node2;
			}
			else
			{
        		text1 = axiom_text_create(env, node1, "Error:1290", &node3); /*unknown error*/
				printf("result : Error\n");
        		return node2;
			}
		}	
	
		sprintf(return_str, "10.35.30.172/get/%s", sha1_str);
        if (!result)
		{
        	text1 = axiom_text_create(env, node1, return_str, &node3);	// Put the www to golf
				printf("result : %s\n",return_str);
		}
		else
		{	
        	text1 = axiom_text_create(env, node1, "Error:1200", &node3);
				printf("result : Error\n");
		}
        return node2;
    }
    AXIS2_ERROR_SET(env->error,
                    AXIS2_ERROR_SVC_SKEL_INVALID_OPERATION_PARAMETERS_IN_SOAP_REQUEST,
                    AXIS2_FAILURE);
    printf("Calculator service ERROR: invalid parameters\n");
    return NULL;
}

axiom_node_t *
axis2_recover(
    const axutil_env_t * env,
    axiom_node_t * node)
{
    axiom_node_t *complex_node = NULL;
    axiom_node_t *seq_node = NULL;
    axiom_node_t *param1_node = NULL;
    axiom_node_t *param1_text_node = NULL;
    axis2_char_t *param1_str = NULL;
    axiom_node_t *param2_node = NULL;
    axiom_node_t *param2_text_node = NULL;
    axis2_char_t *param2_str = NULL;
	axiom_node_t *param3_node = NULL;
    axiom_node_t *param3_text_node = NULL;
    axis2_char_t *param3_str = NULL;

    if (!node)
    {
        AXIS2_ERROR_SET(env->error, AXIS2_ERROR_SVC_SKEL_INPUT_OM_NODE_NULL,
                        AXIS2_FAILURE);
        printf("Make Folder request ERROR: input parameter NULL\n");
        return NULL;
    }

	printf("\nservice : sync\n");
	printf("operation : recover\n");	
    complex_node = axiom_node_get_first_child(node, env);
    if (!complex_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder Param1 Node  ERROR: invalid XML in request\n");
        return NULL;
    }

	// USERNAME

    param1_text_node = axiom_node_get_first_child(complex_node, env);
    if (!param1_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder Param1 Text  ERROR: invalid XML in request\n");
        return NULL;
    }

    if (axiom_node_get_node_type(param1_text_node,env)== AXIOM_TEXT)
    {

	axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param1_text_node, env);
   	if (text && axiom_text_get_value(text, env))
       	{
         	param1_str = (axis2_char_t *) axiom_text_get_value(text, env);
		if (authen(param1_str))
			return NULL;
		printf("param1 (username) : %s\n",param1_str);
       	}
     }
     else
     {
	AXIS2_ERROR_SET(env->error, AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,AXIS2_FAILURE);
	printf("Make Folder Type Mismatch\n");
	return NULL;
     }

	// PATH

    param2_node = axiom_node_get_next_sibling(complex_node, env);
	
    if (!param2_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder ERROR: invalid XML in request\n");
        return NULL;
    }
    param2_text_node = axiom_node_get_first_child(param2_node, env);
	
    if (!param2_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder  ERROR: invalid XML in request\n");
        return NULL;
    }
	
    if (axiom_node_get_node_type(param2_text_node, env) == AXIOM_TEXT)
    {
        axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param2_text_node, env);
        if (text && axiom_text_get_value(text, env))
        {
            param2_str = (axis2_char_t *) axiom_text_get_value(text, env);
			printf("param2 (path) : %s\n",param2_str);
        }
    }
    else
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("AXIOM TEXT ERROR: invalid XML in request\n");
        return NULL;
    }

	// FILE NAME

	param3_node = axiom_node_get_next_sibling(param2_node, env);
	
    if (!param3_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder ERROR: invalid XML in request\n");
        return NULL;
    }
    param3_text_node = axiom_node_get_first_child(param3_node, env);
	
    if (!param3_text_node)
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("Make Folder  ERROR: invalid XML in request\n");
        return NULL;
    }
	
    if (axiom_node_get_node_type(param3_text_node, env) == AXIOM_TEXT)
    {
        axiom_text_t *text = (axiom_text_t *) axiom_node_get_data_element(param3_text_node, env);
        if (text && axiom_text_get_value(text, env))
        {
            param3_str = (axis2_char_t *) axiom_text_get_value(text, env);
			printf("param3 (filename) : %s\n",param3_str);
        }
    }
    else
    {
        AXIS2_ERROR_SET(env->error,
                        AXIS2_ERROR_SVC_SKEL_INVALID_XML_FORMAT_IN_REQUEST,
                        AXIS2_FAILURE);
        printf("AXIOM TEXT ERROR: invalid XML in request\n");
        return NULL;
    }


    if (param1_str && param2_str)
    {
        int result = 0;
		axis2_char_t command[1000];

        axiom_element_t *ele1 = NULL;
		axiom_element_t *ele2 = NULL;
        axiom_node_t *node1 = NULL,
        *node2 = NULL, *node3 = NULL;

        axiom_namespace_t *ns1 = NULL;
        axiom_text_t *text1 = NULL; 
		
		int check=0;
        ns1 = axiom_namespace_create(env,
                                     "http://10.35.30.172:9090/axis2/services/sync/types", "ns1");
        ele1 = axiom_element_create(env, NULL, "result", NULL, &node1);
		ele2 = axiom_element_create(env, NULL, "recoverResponse", ns1, &node2);
		axiom_node_add_child(node2, env, node1);
		char *dest = strndup(param2_str, cut(param2_str));
       
		char *sha1_str = NULL;
		char str[100];
		char return_str[200];

		char temp_php[200];
		char filename[200];
		FILE *fp;
		

		/*
		if(param2_str[strlen(param2_str) - 1] != '/')
		{
			param2_start[strlen(param2_str)] = '/');
			param2_start[strlen(param2_str) + 1] = '\0');
		}
		*/
		if (strcmp(dest,param1_str)==0) /* if you are an owner of a file*/
		{	
			/*CODING HERE*/

			if(param2_str[strlen(param2_str) - 1] != '/')
				sprintf(str, "%s/%s", param2_str, param3_str);
			else
				sprintf(str, "%s%s", param2_str, param3_str);

			sha1_str = sha1(str);
			//tpi1
			sprintf(command,"echo 'in797' >>/home/hadoop/test/z.txt");
			system(command);

			sprintf(command, "rm -rf /var/www/html/get/%s", sha1_str);
			system(command);

			sprintf(command, "mkdir /var/www/html/get/%s", sha1_str);
			system(command);

			sprintf(command, "hadoop dfs -get \"/user/hadoop/.Revision/user/hadoop/%s/%s\" \"/var/www/html/get/%s/%s\"", param2_str, param3_str, sha1_str, param3_str);
			system(command);


			/*sprintf(temp_php, "<?php\nheader(\"Location:%s\");\n?>", param3_str);*/
		
			 sprintf(temp_php,"<?php\n$file = (\"%s\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
			sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);
			fp = fopen(filename, "w+");
			fprintf(fp, "%s", temp_php);
			fclose(fp);

			/*sprintf(temp_php,"DirectoryIndex %s.php", sha1_str);*/
			sprintf(temp_php,"DirectoryIndex %s.php\nRewriteEngine On\nRewriteCond %%{REQUEST_FILENAME} -f [OR]\nRewriteCond %%{REQUEST_FILENAME} -d\nRewriteRule ^(.+) - [PT,L]\n\nRewriteRule ^(.*) %s.php", sha1_str,sha1_str);
			sprintf(filename, "/var/www/html/get/%s/.htaccess", sha1_str);
			fp = fopen(filename,"w+");
			fprintf(fp, "%s", temp_php);
			fclose(fp);
			
		}
		else /* if you request a link from other's person file*/
		{
			check = sharecheck(param1_str, param2_str, dest); /* checking shareing access control*/ 
			if (check==0)
			{
				/* CODING HERE (nearly the same as above)*/

				if(param2_str[strlen(param2_str) - 1] != '/')
					sprintf(str, "%s/%s", param2_str, param3_str);
				else
					sprintf(str, "%s%s", param2_str, param3_str);

				sha1_str = sha1(str);

				//tpi1
				sprintf(command,"echo 'in841' >>/home/hadoop/test/z.txt");
			 	system(command);

				sprintf(command, "rm -rf /var/www/html/get/%s", sha1_str);
				system(command);

				sprintf(command, "mkdir /var/www/html/get/%s", sha1_str);
				system(command);

				sprintf(command, "hadoop dfs -get \"/user/hadoop/.Revision/user/hadoop/%s/%s\" \"/var/www/html/get/%s/%s\"", param2_str, param3_str, sha1_str, param3_str);
				system(command);

				/*sprintf(temp_php, "<?php\nheader(\"Location:%s\");\n?>", param3_str);*/
				

			 sprintf(temp_php,"<?php\n$file = (\"%s\");\nheader(\"Pragma: public\");\nheader(\"Expires: 0 \");\nheader(\"Cache-Control: must-revalidate, post-check=0, pre-check=0\");\nheader (\"Content-Type: application/octet-stream\");\nheader (\"Accept-Ranges: bytes\");\nheader(\"Content-Transfer-Encoding: binary\");\nheader (\"Content-Length: \".filesize($file));\nheader (\"Content-Disposition: attachment; filename=\".$file);\nreadfile($file);\n?>",param3_str);
				/*sprintf(filename, "/var/www/html/get/%s/index.php", sha1_str);*/
				sprintf(filename, "/var/www/html/get/%s/%s.php", sha1_str, sha1_str);


				fp = fopen(filename, "w+");
				fprintf(fp, "%s", temp_php);
				fclose(fp);
				/*sprintf(temp_php,"DirectoryIndex %s.php", sha1_str);*/
				sprintf(temp_php,"DirectoryIndex %s.php\nRewriteEngine On\nRewriteCond %%{REQUEST_FILENAME} -f [OR]\nRewriteCond %%{REQUEST_FILENAME} -d\nRewriteRule ^(.+) - [PT,L]\n\nRewriteRule ^(.*) %s.php", sha1_str,sha1_str);
				sprintf(filename, "/var/www/html/get/%s/.htaccess", sha1_str);
				fp = fopen(filename,"w+");
				fprintf(fp, "%s", temp_php);
				fclose(fp);
			}
			else if (check == 1)
			{
				/* Database Error*/
        		text1 = axiom_text_create(env, node1, "Error:50", &node3);
				printf("result : Error\n");
        		return node2;
			}
			else if (check == -1)
			{
        		text1 = axiom_text_create(env, node1, "Error:1210", &node3); /*path haven't been shared*/
				printf("result : Error\n");
        		return node2;
			}
			else
			{
        		text1 = axiom_text_create(env, node1, "Error:1290", &node3); /*unknown error*/
				printf("result : Error\n");
        		return node2;
			}
		}	
	
		sprintf(return_str, "10.35.30.172/get/%s", sha1_str);
        if (!result)
		{
        	text1 = axiom_text_create(env, node1, return_str, &node3);	// Put the www to golf
				printf("result : %s\n",return_str);
		}
		else
		{	
        	text1 = axiom_text_create(env, node1, "Error:1200", &node3);
				printf("result : Error\n");
		}
        return node2;
    }
    AXIS2_ERROR_SET(env->error,
                    AXIS2_ERROR_SVC_SKEL_INVALID_OPERATION_PARAMETERS_IN_SOAP_REQUEST,
                    AXIS2_FAILURE);
    printf("Calculator service ERROR: invalid parameters\n");
    return NULL;
}

