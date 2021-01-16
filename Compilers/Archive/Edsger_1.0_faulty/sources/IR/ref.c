bool condition (const struct Variable*& v) { return (strcmp(v->name,currentName)==0); }

void reform(std::list<std::list<struct Variable *> *> *VQ,std::vector<llvm::Type*> *argTypes,struct dec_node *dec_head,struct dec_node *dec_tail, int *dec_count, std::list<struct Variable *> *call_app){
	std::list<struct Variable*> list;
	SymbolEntry *s;
	Type *t;
	struct Variable* m;
	for (std::list<std::list<struct Variable *> *>::const_iterator i = VQ->begin(); i != VQ->end(); ++i) {
	    	for(std::list<struct Variable *>::const_iterator j = (*i)->begin(); j!=(*i)->end(); ++j){
			m = new struct Variable;
			strcpy(m->name,(*j)->name);
			list.push_front(m);
		}
	}
	while(!list.empty()){
		m = list.back();
		s = lookup(m->name,LOOKUP_ALL_SCOPES);
		if(s==NULL){
			fprintf(stdout,"WRONG LOOKUP on name %s\n",m->name);
			return ;
		}else{
			if(s->entryType == ENTRY_VARIABLE){
				t = s->u.eVariable->type;
			}
			else if(s->entryType == ENTRY_PARAMETER){
				t = s->u.eParameter->type;
			}
			else{
				fprintf(stdout,"WRONG LOOKUP on name %s\n",m->name);
				return ;
			}
		}

		if(dec_head == NULL){
			dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
			dec_head->type = t;
			dec_head->next = NULL;
			strcpy((dec_head)->name,m->name);	
			dec_head)->by_ref_idx = 1;
			dec_tail = dec_head;
			*dec_count = 1;
		}else{
			dec_tail->next = (struct dec_node *)malloc(sizeof(struct dec_node));
			dec_tail = (dec_tail)->next;
			strcpy(dec_tail->name, m->name);
			(dec_tail)->type = t;
			(dec_tail)->by_ref_idx = 1;		
			(dec_tail)->next = NULL;
			(*dec_count)++;
		}
		argTypes->push_back(typeOf(typePointer(t)));
		list.pop_back();
		call_app->push_back(m);
		strcpy(currentName,m->name);
		list.removeif(condition);
	}
}















			if((p->entryType)==ENTRY_VARIABLE) {
				$$.adr =  (s->u).eVariable.alloc;
			}
			else if((s->entryType)==ENTRY_PARAMETER){
					if((s->u).eParameter.mode == PASS_BY_REFERENCE){
						$$.val = currentBuilder->CreateLoad ( $$.adr, "Tid_create_load_param_brf");
					}
